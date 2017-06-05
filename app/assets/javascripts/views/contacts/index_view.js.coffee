window.Views.Contacts ||= {}

class Views.Contacts.IndexView extends Views.BaseView
  el: '.contacts-container'
  ui:
    searchBox: '.contacts__search-box'
    searchBoxInput: '.contacts__search-box input'
    listContainer: '.contacts__list'
    loadMore: '.js-loadmore'

  render: ->
    @$ui.searchBox.find('form').on 'submit', (event) => @onSearch(event)
    @$ui.listContainer.on 'click', '.js-remove', (event) => @onRemove(event)
    @$ui.loadMore.on 'click', (event) => @onLoadMore(event)
    @$ui.loadMore.trigger 'click'

    MessageBus.subscribe "/contact-channel", @onSubscribe

  cleanup: ->
    @$ui.listContainer.html("")

  onSearch: (event) ->
    event.preventDefault()
    contactedId = @$ui.searchBoxInput.val()
    return if contactedId == ""

    payload =
      url: '/contacts'
      method: 'POST'
      data:
        contacted_id: contactedId
    $.ajax(payload).success (data) =>
      alert "Add user #{data.contacted_id} successful"
      @$ui.listContainer.prepend(@contactDom(data))
    .fail (response) =>
      alert response.responseJSON.message

  onLoadMore: (event) ->
    $target = $(event.currentTarget)
    @pageSize ||= parseInt($(event.currentTarget).attr("data-pageSize"))

    payload =
      url: '/contacts'
      method: 'GET'
      data:
        marker: @marker
    $.ajax(payload).success (data) =>
      appendContacts = ""
      for contact in data
        appendContacts += @contactDom(contact)
      @$ui.listContainer.append(appendContacts)

      if data.length < @pageSize
        @$ui.loadMore.hide()
      else
        @marker = data.pop().id

    .fail (response) =>
      alert response.responseJSON.message

  onRemove: (event) =>
    $target = $(event.currentTarget)
    id = $target.attr("data-id")

    payload =
      url: "/contacts/#{id}"
      method: 'DELETE'

    $.ajax(payload).success (data) =>
      $target.closest(".contacts__item").remove()
    .fail (response) =>
      alert response.responseJSON.message

  onSubscribe: (data) =>
    if data.new_record
      @$ui.listContainer.prepend(@contactDom(data))
    else
      $item = @$ui.listContainer.find("#contacts__item-#{data.id}")
      $item.html(@contactDom(data))

  contactDom: (contact) =>
    itemClass = "contacts__item"
    if contact.new_message > 0
      itemClass += " new-message-container"

    """
      <div class="#{itemClass}" id="contacts__item-#{contact.id}">
        <label>#{contact.contacted_id}</label>
        <span class="new-message__cycle">#{contact.new_message}</span>
        <div class="btn-group pull-right">
          <a class="btn btn-default btn-xs" href="/chats/show?cid=#{contact.contacted_id}">
            <span class="glyphicon glyphicon-envelope"></span>
          </a>
          <button class="btn btn-default btn-xs js-remove" data-id=#{contact.id}>
            <span class="glyphicon glyphicon-remove"></span>
          </button>
        </div>
      </div>
    """
