// see https://community.folivora.ai/t/close-all-notification-alerts-notification-center-is-not-working-on-macos-sequoia-15-0/39200/34
Application("System Events")
  .applicationProcesses.byName("NotificationCenter")
  .windows[0]
  .groups[0]
  .groups[0]
  .scrollAreas[0]
  .uiElements()
  .map(banner => banner.actions().slice(-1)[0])
  .forEach(banner => banner.perform())