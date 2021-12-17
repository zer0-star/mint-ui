/* A component which traps focus inside itself. */
component Ui.FocusTrap {
  /* The children to render. */
  property children : Array(Html) = []

  /* Handles the keydown event. */
  fun handleKeyDown (event : Html.Event) {
    case (base) {
      Maybe::Just(element) =>
        if (event.keyCode == 9) {
          target =
            Maybe::Just(event.target)

          elements =
            element.getFocusableElements()

          first =
            elements.first()

          last =
            elements.last()

          if (event.shiftKey && first == target) {
            event.preventDefault()
            last.focus()
          } else if (!event.shiftKey && last == target) {
            event.preventDefault()
            first.focus()
          } else {
            next { }
          }
        } else {
          next { }
        }

      => next { }
    }
  }

  /* Renders the component. */
  fun render : Html {
    <div as base onKeyDown={handleKeyDown}>
      <{ children }>
    </div>
  }
}
