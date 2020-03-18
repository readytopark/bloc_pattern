import ...

class SimpleBlocDelegate extends BlocDelegate {
  final bool isDev;

  SimpleBlocDelegate(this.isDev);

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);

    if (isDev) {
      print(event);
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    if (isDev) {
      print(transition);
    }
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);

    if (isDev) {
      print('$error, $stacktrace');
    }

    Crashlytics.instance.recordError(error, stacktrace);
  }
}
