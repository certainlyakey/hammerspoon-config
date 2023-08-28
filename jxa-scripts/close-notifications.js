"use strict";

function run() {
  const SystemEvents = Application("System Events");
  const NotificationCenter =
    SystemEvents.processes.byName("NotificationCenter");
  const notificationGroups = () => {
    const windows = NotificationCenter.windows;
    return windows.length === 0
      ? []
      : windows.at(0).groups.at(0).scrollAreas.at(0).uiElements.at(0).groups();
  };

  const findCloseAction = (group) => {
    const [closeAllAction, closeAction] = group.actions().reduce(
      (matches, action) => {
        switch (action.description()) {
          case "Clear All":
            return [action, matches[1]];
          case "Close":
            return [matches[0], action];
          default:
            return matches;
        }
      },
      [null, null]
    );
    return closeAllAction ?? closeAction;
  };

  const actions = notificationGroups().map(findCloseAction);
  for (const action of actions) {
    action?.perform();
  }
}
