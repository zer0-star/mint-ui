/* A definition list component. */
component Ui.DefinitionList {
  /* The data for the rows. */
  property rows : Array(Tuple(String, Array(Ui.Cell))) = []

  /* The size of the list. */
  property size : Ui.Size = Ui.Size::Inherit

  /* The data for the headers. */
  property headers : Array(String) = []

  /* The data for the state. */
  state data : Set(Number) = Set.empty()

  /* Style for the base element. */
  style base {
    border: 0.0625em solid var(--content-border);
    border-bottom: 0;

    background: var(--content-color);
    color: var(--content-text);

    font-family: var(--font-family);
    font-size: #{size.toString()};
    line-height: 170%;
  }

  /* The styles for the details element. */
  style details (open : Bool) {
    &:not(:last-of-type) {
      if (open) {
        border-bottom: 0.1875em solid var(--content-border);
      }
    }

    &:last-of-type {
      if (open) {
        border-bottom: 0.0625em solid var(--content-border);
      }
    }
  }

  /* Styles for the summary element. */
  style summary (open : Bool) {
    border-bottom: 0.0714em solid var(--content-border);
    box-sizing: border-box;
    padding: 0.857em;

    grid-template-columns: auto 1fr;
    align-items: center;
    grid-gap: 0.571em;
    display: grid;

    font-size: 0.875em;
    font-weight: bold;

    cursor: pointer;
    outline: none;

    &:focus,
    &:hover {
      background: var(--primary-light-color);
      color: var(--primary-light-text);
    }

    svg {
      if (open) {
        transform: rotate(90deg);
      }
    }
  }

  /* Styles for a cell. */
  style cell {
    line-height: 1;
  }

  /* Styles for a label. */
  style label {
    line-height: 1.25em;
    font-weight: bold;
    font-size: 0.75em;
    opacity: 0.5;
  }

  /* Styles for an item. */
  style item {
    grid-gap: 0.25em;
    padding: 0.75em;
    display: grid;

    + * {
      border-top: 0.0625em solid var(--content-border);
    }
  }

  fun handleClick (index : Number) : Function(Promise(Void)) {
    () {
      if (data.has(index)) {
        next { data = data.delete(index) }
      } else {
        next { data = data.add(index) }
      }
    }
  }

  /* Renders the list. */
  fun render : Html {
    <div::base>
      <{
        rows.mapWithIndex(
          (row : Tuple(String, Array(Ui.Cell)), index : Number) {
            {summary, cells} =
              row

            open =
              data.has(index)

            <>
              <div::details(open)>
                <div::summary(open) onClick={handleClick(index)}>
                  <Ui.Icon icon={Ui.Icons:CHEVRON_RIGHT}/>

                  <div::cell>
                    <{ summary }>
                  </div>
                </div>

                if (open) {
                  <div>
                    for (cell of cells) {
                      header =
                        headers.at(Array.indexOf(cell, cells)) or ""

                      <div::item>
                        <div::label>
                          <{ header }>
                        </div>

                        <div>
                          <Ui.Cell cell={cell}/>
                        </div>
                      </div>
                    }
                  </div>
                }
              </div>
            </>
          })
      }>
    </div>
  }
}
