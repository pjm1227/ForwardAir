import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/apirepo/repository.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/models/error_model.dart';
import 'package:forwardair_fleet_management/models/webservice/revenue_request.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'barrels/revenue.dart';

class RevenueDetailsBloc
    extends Bloc<RevenueDetailsEvent, RevenueDetailsState> {
  @override
  RevenueDetailsState get initialState => InitialState();

  @override
  Stream<RevenueDetailsState> mapEventToState(
    RevenueDetailsEvent event,
  ) async* {
    if (event is FetchRevenueDetailsEvent) {
      yield* _makeApiCall(event);
    }
  }

  //This method is check internet first, If we have internet connection
  // then call an API else Check if data exists in DB, If we have data in db then
  // Show it from DB else show some error
  Stream<RevenueDetailsState> _makeApiCall(
      FetchRevenueDetailsEvent event) async* {
    //Check for internet connection first
    var isConnection = await Utils.isConnectionAvailable();
    if (isConnection) {
      //Internet Connection available, So Make API call
      //Fetch user tokens from User table
      var userManager = UserManager();
      var userModel = await userManager.getData();
      if (userModel.token != null) {
        var repository = Repository();
        //Create a request Model
        var request = RevenueRequest(
            oid: event.oid, transactionType: event.transactionType);
        //Convert request model to json
        var body = request.toJson();
        print(body.toString());
        var result = await repository.makeRevenueDetailsRequest(
            userModel.token, body.toString());
        //Check if result is an instance of RevenueDetailsModel or ErrorModel
        //If it's TractorModel then insert data into DB else show error message
        if (result is ErrorModel) {
          print('Error found in Revenue Details API');
          //Show some error
          yield RevenueErrorState(errorMessage: result.errorMessage);
        } else {
          try {
            var tractorRevenueModel;
            if (event.transactionType == 'E') {
              //Data found for Tractors
              tractorRevenueModel = tractorRevenueModelFromJson(result);
            } else {
              tractorRevenueModel = revenueDeductionModelFromJson(result);
            }

            print('Revenue Data Found');

            yield RevenueSuccessState(tractorRevenueModel: tractorRevenueModel);
          } catch (_) {
            yield RevenueErrorState(errorMessage: '');
            print("db Exception");
          }
        }
      } else {
        yield RevenueErrorState(errorMessage: Constants.SOMETHING_WRONG);
      }
    } else {
      //No internet connection, So fetch Data from DB
      yield RevenueErrorState(errorMessage: Constants.NO_INTERNET_FOUND);
    }
  }
}
