suite "Ui.Button" {
  test "renders the label" {
    <Ui.Button label="Hello"/>
      .start()
      .assertTextOf("button", "Hello")
  }

  test "handles click events" {
    handler =
      (event : Html.Event) { Promise.never() }
      |> Test.Context.spyOn()

    <Ui.Button onClick={handler}/>
      .start()
      .triggerClick("button")
      .assertFunctionCalled(handler)
  }

  test "handles mouse down events" {
    handler =
      (event : Html.Event) { Promise.never() }.spyOn()

    <Ui.Button onMouseDown={handler}/>
      .start()
      .triggerMouseDown("button")
      .assertFunctionCalled(handler)
  }

  test "handles mouse up events" {
    handler =
      (event : Html.Event) { Promise.never() }.spyOn()

    <Ui.Button onMouseUp={handler}/>
      .start()
      .triggerMouseUp("button")
      .assertFunctionCalled(handler)
  }
}

suite "Ui.Button - Disabled" {
  test "always renders as button" {
    <Ui.Button
      disabled={true}
      label="Hello"
      href="/"/>
      .start()
      .assertTextOf("button", "Hello")
  }

  test "doesn't handle click events" {
    handler =
      (event : Html.Event) { Promise.never() }.spyOn()

    <Ui.Button
      onClick={handler}
      disabled={true}/>
      .start()
      .triggerClick("button")
      .assertFunctionNotCalled(handler)
  }

  test "doesn't handle mouse down events" {
    handler =
      (event : Html.Event) { Promise.never() }.spyOn()

    <Ui.Button
      onMouseDown={handler}
      disabled={true}/>
      .start()
      .triggerMouseDown("button")
      .assertFunctionNotCalled(handler)
  }

  test "doesn't handle mouse up events" {
    handler =
      (event : Html.Event) { Promise.never() }
        .spyOn()

    <Ui.Button
      onMouseUp={handler}
      disabled={true}/>
      .start()
      .triggerMouseUp("button")
      .assertFunctionNotCalled(handler)
  }
}
