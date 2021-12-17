/* A vertical list the user can interact with using the keyboard. */
component Ui.InteractiveList {
  /* The select event handler (when an item is clicked). */
  property onClickSelect : Function(String, Promise(Void)) = Promise.never1

  /* The select event handler. */
  property onSelect : Function(String, Promise(Void)) = Promise.never1

  /* The selected set of items. */
  property selected : Set(String) = Set.empty()

  /* The size of the list. */
  property size : Ui.Size = Ui.Size::Inherit

  /* The items to render. */
  property items : Array(Ui.ListItem) = []

  /* Whether or not the list is interactive. */
  property interactive : Bool = true

  /* Whether or not the user can intend to select an element. */
  property intendable : Bool = false

  /* The current intended element. */
  state intended : String = ""

  /* The styles for the base. */
  style base {
    font-size: #{Ui.Size.toString(size)};
    outline: none;

    if (interactive) {
      padding: 0.125em;
    }

    &:focus {
      if (interactive) {
        outline: 0.125em solid var(--primary-color);
      }
    }
  }

  /* The styles for the items. */
  style items {
    grid-gap: 0.3125em;
    display: grid;
  }

  /* Intend the first element when the component is mounted. */
  fun componentDidMount {
    next { intended = selected.toArray().first() or "" }
  }

  /* Sets the intended element. */
  fun intend (value : String) {
    next { intended = value }
  }

  /* Handles a select event. */
  fun handleSelect (value : String) {
    intend(value)
    onSelect(value)
  }

  /* Handles a select event (when the item is clicked). */
  fun handleClickSelect (value : String) {
    intend(value)
    onClickSelect(value)
  }

  /* Selects the next or previous element. */
  fun selectNext (forward : Bool) : Promise(Void) {
    itemsOnly =
      items.select(
        (item : Ui.ListItem) {
          case (item) {
            Ui.ListItem::Divider => false
            Ui.ListItem::Item => true
          }
        })

    index =
      itemsOnly.indexBy(intended, Ui.ListItem.key)

    nextIndex =
      if (forward) {
        if (index == itemsOnly.size() - 1) {
          0
        } else {
          index + 1
        }
      } else if (index == 0) {
        itemsOnly.size() - 1
      } else {
        index - 1
      }

    nextKey =
      itemsOnly[nextIndex].map(Ui.ListItem.key) or ""

    if (intendable) {
      intend(nextKey)
    } else {
      handleSelect(nextKey)
    }

    case (container) {
      Maybe::Just(element) => Ui.scrollIntoViewIfNeeded(`#{element}.children[#{nextIndex}]`)
      => next { }
    }
  }

  /* Handles the keydown event. */
  fun handleKeyDown (event : Html.Event) {
    case (event.keyCode) {
      Html.Event:ENTER => onSelect(intended)

      Html.Event:SPACE =>
        {
          event.preventDefault()
          onSelect(intended)
        }

      Html.Event:DOWN_ARROW =>
        {
          event.preventDefault()
          selectNext(true)
        }

      Html.Event:UP_ARROW =>
        {
          event.preventDefault()
          selectNext(false)
        }

      => next { }
    }
  }

  /* Renders the list. */
  fun render : Html {
    tabIndex =
      if (interactive) {
        "0"
      } else {
        "-1"
      }

    <div::base
      onKeyDown={Ui.disabledHandler(!interactive, handleKeyDown)}
      tabindex={tabIndex}>

      <Ui.ScrollPanel>
        <div::items as container>
          for (item of items) {
            case (item) {
              Ui.ListItem::Item(key, content) =>
                <Ui.InteractiveList.Item
                  onClick={(event : Html.Event) { handleClickSelect(key) }}
                  intended={intendable && key == intended}
                  selected={selected.has(key)}
                  key={key}>

                  <{ content }>

                </Ui.InteractiveList.Item>

              Ui.ListItem::Divider => <div/>
            }
          }
        </div>
      </Ui.ScrollPanel>

    </div>
  }
}
