do ->
  class com.roost.SubscriptionPanel extends Backbone.View
    className: 'subscription-panel'

    events:
      'click .subscribe': '_addSubscription'
      'click .close-td': '_removeSubscription'
      'click .class-td': '_addClassPane'
      'click .remove': '_hide'

      'keyup input': '_handleInputKey'

    initialize: (options) =>
      @subscriptions = options.subscriptions
      @settings = options.settings
      @session = options.session

      @listenTo @subscriptions, 'add remove reset sort', @render
      @listenTo @settings, 'change:showSubs', @_toggleDisplay
      @listenTo @settings, 'change:showNavbar', @_hide

    render: =>
      @$el.empty()
      template = com.roost.templates['SubscriptionPanel']
      @$el.append template(@subscriptions)

      @_toggleDisplay()

    _toggleDisplay: =>
      if @settings.get('showSubs')
        @$el.addClass('expanded')
        @$('.class-input').focus()
      else
        @$el.removeClass('expanded')
        @$('.class-input').blur()
        @$('.class-input').val('')
        @$('.instance-input').val('*')
        @$('.recipient-input').val('')

    _hide: =>
      @settings.set('showSubs', false)

    _addClassPane: (evt) =>
      klass = $(evt.target).data().class
      options = 
        filters: 
          class_key: klass.toLowerCase()

      @session.addPane options

    _addSubscription: =>
      opts = 
        class: @$('.class-input').val()
        instance: @$('.instance-input').val()
        recipient: @$('.recipient-input').val()

      # Only add the fields we actually have
      sub = {}
      if opts.class != ''
        sub.class = opts.class
      if opts.instance != ''
        sub.instance = opts.instance
      if opts.recipient != ''
        sub.recipient = opts.recipient

      @subscriptions.add sub
      console.log @subscriptions.models

    _removeSubscription: (evt) =>
      @subscriptions.remove($(evt.target).data().cid)

    _handleInputKey: (evt) =>
      # Enter and escape key handling in the input boxes
      if evt.keyCode == 13
        @_addSubscription()
      else if evt.keyCode == 27
        @settings.set 'showSubs', false