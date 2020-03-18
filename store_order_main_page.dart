import ...

class _StoreOrderMainPageBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StoreOrderMainPageBodyState();
  }
}

class _StoreOrderMainPageBodyState extends State<_StoreOrderMainPageBody>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  ...

  @override
  Widget build(BuildContext context) {
    StoreCatalog storeCatalog = Provider.of<StoreCatalog>(context);

    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, isBoxScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                child: buildStoreInfoCard(context, storeCatalog),
              ),
            ),
            ...
          ];
        },
        body: TabBarView(
            controller: _tabController,
            children: List.generate(_tabController.length, (index) {
              return buildTabBarView(context, storeCatalog.categories[index]);
            })),
      ),
    );
  }

  ...

}

class StoreOrderMainPage extends StatefulWidget {
  final int storeId;

  const StoreOrderMainPage({Key key, this.storeId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StoreOrderMainPageState();
  }
}

class _StoreOrderMainPageState extends State<StoreOrderMainPage> with WidgetBinder {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc;

    try {
      accountBloc = BlocProvider.of<AccountBloc>(context);
    } catch (e) {}

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(...),
      body: BlocProvider<StoreOrderMainPageBloc>(
        create: (context) {
          Services services = Services.of(context);

          return StoreOrderMainPageBloc(
              StoreRepositoryImpl(services.restApiResource, services.webSocketApiResource))
            ..add(StoreOrderMainPageEventLoadCatalog(widget.storeId));
        },
        child: BlocListener<StoreOrderMainPageBloc, StoreOrderMainPageState>(
          listener: (context, state) {
            if (state is StoreOrderMainPageStateLoading) {
              showLoadingDialog(context);
            } else {
              dismissLoadingDialog(context);
            }
          },
          child: BlocBuilder<StoreOrderMainPageBloc, StoreOrderMainPageState>(
            builder: (context, state) {
              if (state is StoreOrderMainPageStateLoadCatalogSuccess) {
                return Provider<StoreCatalog>(
                  create: (context) => state.result,
                  child: _StoreOrderMainPageBody(),
                );
              } else if (state is StoreOrderMainPageStateLoadCatalogFailure) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.red,
                  child: Text(
                    state.errMsg,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
