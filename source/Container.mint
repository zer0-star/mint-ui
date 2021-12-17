/* A container where the items are separated by a gap. */
component Ui.Container {
  /* The orientation of the grid, either `horizontal` or `vertical`. */
  property orientation : String = "horizontal"

  /* Where to justify the content. */
  property justify : String = "stretch"

  /* Where to align the items. */
  property align : String = "center"

  /* The size of the grid. */
  property size : Ui.Size = Ui.Size::Inherit

  /* The gap between the children. */
  property gap : Ui.Size = Ui.Size::Em(0.5)

  /* The children to render. */
  property children : Array(Html) = []

  /* Styles for the base element. */
  style base {
    font-size: #{size.toString()};

    justify-content: #{justify};
    align-items: #{align};
    display: flex;

    if (orientation == "horizontal") {
      flex-direction: row;
    } else {
      flex-direction: column;
    }
  }

  /* Styles for the gap. */
  style gap {
    height: #{gap.toString()};
    width: #{gap.toString()};
    flex: 0 0 auto;
  }

  /* Renders the component. */
  fun render : Html {
    <div::base>
      <{ children.flatten().intersperse(<div::gap/>) }>
    </div>
  }
}
