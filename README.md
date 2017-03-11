
# SimpleLists

This is a simple macOS app that lets you create a list of items. You can select an item from the list and hit delete to remove it.

![screenshot](https://github.com/allenu/SimpleLists/raw/master/images/screenshot.png)

This project illustrates a few basic macOS concepts.

- Document-based app
- Loading and saving to a simple JSON file using JSONSerialization
- Setting up simple view-based NSTableView
- Handling delete key to remove selected item in a table view
- Handling undo/redo stack using NSUndoManager

The NSUndoManager stuff is a little tricky the first you try to understand it. The important things to note:
- Have a central place in the view controller for each of the undo-able actions and call those directly from the UI handlers. 
  For instance, here it's the ViewController add(name:, at:) and remove(at:) methods.
- Make you pass in all the information you need to make the change as parameters. Do not rely on any state in these handlers.
  This is important because the state you are in before you do the undo-able action (say, the number of items in the list)
  will differ from the state after you do the action. An earlier implementation of my add() method used the number of items
  currently in the list when registering the remove() call in the undo operation. I should've used the index of item being
  added instead. My error led to weird behavior that was confusing to reason about because of the state.

This video helped me understand how to use NSUndoManager: https://www.youtube.com/watch?v=WJaHOnftNIY