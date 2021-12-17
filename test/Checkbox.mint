suite "Ui.Checkbox" {
  test "triggers change event" {
    handler =
      (event : Bool) { Promise.never() }.spyOn()

    <Ui.Checkbox onChange={handler}/>
      .start()
      .triggerClick("button")
      .assertFunctionCalled(handler)
  }
}

suite "Ui.Checkbox - Disabled" {
  test "does not trigger change event" {
    handler =
      (event : Bool) { Promise.never() }.spyOn()

    <Ui.Checkbox
      onChange={handler}
      disabled={true}/>
      .start()
      .triggerClick("button")
      .assertFunctionNotCalled(handler)
  }
}
