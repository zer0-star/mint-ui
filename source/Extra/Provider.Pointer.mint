/* Represents a subscription for `Provider.Pointer` */
record Provider.Pointer.Subscription {
  downs : Function(Html.Event, Promise(Void)),
  moves : Function(Html.Event, Promise(Void)),
  ups : Function(Html.Event, Promise(Void))
}

/* A provider for global Pointer events. */
provider Provider.Pointer : Provider.Pointer.Subscription {
  /* The listener unsubscribe functions. */
  state listeners : Maybe(Tuple(Function(Void), Function(Void), Function(Void))) = Maybe::Nothing

  /* Updates the provider. */
  fun update : Promise(Void) {
    if (Array.isEmpty(subscriptions)) {
      listeners.map(
        (
          methods : Tuple(Function(Void), Function(Void), Function(Void))
        ) {
          {downListener, moveListener, upListener} =
            methods

          downListener()
          moveListener()
          upListener()
        })

      next { listeners = Maybe::Nothing }
    } else {
      case (listeners) {
        Maybe::Nothing =>
          next
            {
              listeners =
                Maybe::Just(
                  {
                    Window.addEventListener(
                      "pointerdown",
                      true,
                      (event : Html.Event) {
                        for (subscription of subscriptions) {
                          subscription.downs(event)
                        }
                      }),
                    Window.addEventListener(
                      "pointermove",
                      false,
                      (event : Html.Event) {
                        for (subscription of subscriptions) {
                          subscription.moves(event)
                        }
                      }),
                    Window.addEventListener(
                      "pointerup",
                      false,
                      (event : Html.Event) {
                        for (subscription of subscriptions) {
                          subscription.ups(event)
                        }
                      })
                  })
            }

        => next { }
      }
    }
  }
}
