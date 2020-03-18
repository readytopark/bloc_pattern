import ...

abstract class StoreOrderMainPageState extends Equatable {
  StoreOrderMainPageState([List props = const []]) : super(props);
}


class StoreOrderMainPageStateDefault extends StoreOrderMainPageState {}

class StoreOrderMainPageStateLoading extends StoreOrderMainPageState {}

class StoreOrderMainPageStateLoadCatalogSuccess extends StoreOrderMainPageState {
  final StoreCatalog result;

  StoreOrderMainPageStateLoadCatalogSuccess(this.result) : super([result]);
}

class StoreOrderMainPageStateLoadCatalogFailure extends StoreOrderMainPageState {
  final String errMsg;

  StoreOrderMainPageStateLoadCatalogFailure(this.errMsg) : super([errMsg]);
}

abstract class StoreOrderMainPageEvent extends Equatable {
  StoreOrderMainPageEvent([List props = const []]) : super(props);
}

class StoreOrderMainPageEventLoadCatalog extends StoreOrderMainPageEvent {
  final int storeId;

  StoreOrderMainPageEventLoadCatalog(this.storeId) : super([storeId]);
}

class StoreOrderMainPageBloc extends Bloc<StoreOrderMainPageEvent, StoreOrderMainPageState> {
  final StoreRepository storeRepository;

  StoreOrderMainPageBloc(this.storeRepository);

  @override
  get initialState => StoreOrderMainPageStateDefault();

  @override
  Future<void> close() async {
    storeRepository?.dispose();
    await super.close();
  }

  @override
  Stream<StoreOrderMainPageState> mapEventToState(StoreOrderMainPageEvent event) async* {
    if (event is StoreOrderMainPageEventLoadCatalog) {
      yield StoreOrderMainPageStateLoading();

      try {
        StoreCatalog storeCatalog = await storeRepository.loadStoreCatalog(event.storeId);

        yield StoreOrderMainPageStateLoadCatalogSuccess(storeCatalog);
      } catch (e) {
        yield StoreOrderMainPageStateLoadCatalogFailure(e.toString());
      }
    }
  }

  StoreCatalogDiscount getStoreCatalogDiscount(int discountId) {
    if (state is StoreOrderMainPageStateLoadCatalogSuccess) {
      StoreCatalog storeCatalog = (state as StoreOrderMainPageStateLoadCatalogSuccess).result;
      return this.storeRepository.getStoreCatalogDiscount(storeCatalog, discountId);
    } else {
      return null;
    }
  }
}
