

class HomePageBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageBodyState();
  }
}

class _HomePageBodyState extends State<HomePageBody> with WidgetBinder, TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (BuildContext context, HomePageState state) {
        ...

        onPressed: () {

          AccountBloc accountBloc = BlocProvider.of<AccountBloc>(context);

          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => BlocProvider.value(value: accountBloc, child: StoreOrderMainPage()),
          ));
        },
        ...
      });
  }
}

class HomePage extends StatefulWidget {
  
  ...

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with WidgetBinder {

  ...

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountBloc>(create: (context) {
          Services services = Services.of(context);

          return AccountBloc(
              BlocProvider.of<ApplicationBloc>(context),
              AccountRepositoryImpl(services.webSocketApiResource,
                  services.securePersistenceResource, services.simplePersistenceResource),
              services.appConfig)
            ..add(AccountEventCheck());
        }),
        BlocProvider<HomePageBloc>(
          create: (context) {
            ...
          },
        )
      ],
      child: HomePageBody(),
    );
  }
}
