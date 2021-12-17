suite "Ui.Toggle" {
  test "triggers change event" {
    handler =
      (event : Bool) { Promise.never() }.spyOn()

    <Ui.Toggle onChange={handler}/>
      .start()
      .triggerClick("button")
      .assertFunctionCalled(handler)
  }
}

suite "Ui.Toggle - Disabled" {
  test "does not trigger change event" {
    handler =
      (event : Bool) { Promise.never() }.spyOn()

    <Ui.Toggle
      onChange={handler}
      disabled={true}/>
      .start()
      .triggerClick("button")
      .assertFunctionNotCalled(handler)
  }
}
