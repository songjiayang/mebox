window.Views.Chats ||= {}

class Views.Chats.ShowView extends Views.BaseView
  el: '.chat-container'
  ui:
    messageBox: '.chat__message-box'
    chatForm: '.chat__form'
    chatTextarea: '.chat__form textarea'
    loadMore: '.js-loadmore'

  render: ->
    @reciverId = parseInt(@$ui.messageBox.attr("data-reciver-id"))
    @contactId = parseInt(@$ui.messageBox.attr("data-contact-id"))

    @$ui.chatForm.on 'submit', (event) => @onSentMessage(event)
    @$ui.messageBox.on 'click', '.js-remove', (event) => @onRemove(event)
    @$ui.loadMore.on 'click', (event) => @onLoadMore(event)
    @$ui.loadMore.trigger("click")

    userId = @$ui.messageBox.attr("data-user-id")

    MessageBus.subscribe "/chatchannel-#{userId}-#{@reciverId}", @onSubscribe

  cleanup: ->
    @$ui.messageBox.html("")

  onSentMessage: (event) ->
    event.preventDefault()
    payload =
      url: '/messages'
      method: 'POST'
      data:
        message:
          content: @$ui.chatTextarea.val()
          reciver_id: @reciverId

    $.ajax(payload).success (data) =>
      @$ui.messageBox.append(@messageItemDom(data))
      @$ui.chatTextarea.val("")
    .fail (response) =>
      alert response.responseJSON.message

  onRemove: (event) =>
    $target = $(event.currentTarget)
    messageId = $target.attr("data-message-id")

    payload =
      url: "/messages/#{messageId}"
      method: 'DELETE'

    $.ajax(payload).success (data) =>
      $target.closest(".message__item").remove()
    .fail (response) =>
      alert response.responseJSON.message

  onLoadMore: (event) =>
    @pageSize ||= parseInt($(event.currentTarget).attr("data-page-size"))
    payload =
      url: "/messages"
      method: 'GET'
      data:
        marker: @marker
        reciver_id: @reciverId
    $.ajax(payload).success (data) =>
      appendMessages = ""
      for message in data
        appendMessages = @messageItemDom(message) + appendMessages
      @$ui.messageBox.prepend(appendMessages)

      if data.length < @pageSize
        @$ui.loadMore.hide()
      else
        @marker = data.pop().id
    .fail (response) =>
      alert response.responseJSON.message

  onSubscribe: (data) =>
    @$ui.messageBox.append(@messageItemDom(data))

    # touch contact new_message
    payload =
      url: "/contacts/#{@contactId}"
      method: 'PATCH'
    $.ajax(payload).fail (response) =>
      console.log response.responseJSON.message

  messageItemDom: (message) =>
    if message.sender_id != @reciverId
      """
        <div class="message__item row">
          <div class="col-xs-12">
            <div class="alert message__item-content alert-success pull-right">
              #{message.content}
              <button class="btn btn-danger btn-xs pull-right js-remove" data-message-id=#{message.id}>
                <span class="glyphicon glyphicon-remove"></span>
              </button>
            </div>
          </div>
        </div>
      """
    else
      """
        <div class="message__item row">
          <div class="col-xs-12">
            <div class="alert message__item-content alert-info pull-left">
              #{message.content}
            </div>
          </div>
        </div>
      """
