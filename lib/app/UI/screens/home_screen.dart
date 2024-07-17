import 'package:assesment1/app/UI/screens/user_details_screen.dart';
import 'package:assesment1/app/UI/widgets/user_widget.dart';
import 'package:assesment1/app/app_styles/app_color.dart';
import 'package:assesment1/app/app_styles/style.dart';
import 'package:assesment1/app/state_management/user_cubit.dart';
import 'package:assesment1/app/utils/common_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:toastification/toastification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () => Future.sync(
            // Refresh through page controllers
            () => _pagingController.refresh(),
          ),
          child: Scaffold(
            backgroundColor: CupertinoColors.white,
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "User List",
                style: Style.nameTextStyle,
              ),
            ),
            body: PagedListView<int, dynamic>.separated(
              padding: const EdgeInsets.all(15),
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<dynamic>(
                  animateTransitions: true,
                  itemBuilder: (_, item, index) {
                    return UserWidget(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>  UserDetailsScreen(userId: item.userId,),
                          ),
                        );
                      },
                      firstName: item.firstName,
                      lastName: item.lastName,
                      email: item.email,
                      profileLink: item.profileUrl,
                    );
                  }),
              separatorBuilder: (_, index) => const SizedBox(
                height: 5,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final userListData =
          await context.read<UserCubit>().fetchUserListData(pageKey);
      if (mounted) {
        if (context.read<UserCubit>().responseStatusCode == 200) {
          CommonFunctions.showToast(
              "Details fetched successfully", ToastificationType.success);
          final isLastPage =
              userListData.dataList!.length < userListData.perPage!;
          // If it is last page then add last page
          if (isLastPage) {
            _pagingController.appendLastPage(userListData.dataList!);
          } else {
            // Add new page when it is not last page
            final nextPageKey = pageKey + 1;
            _pagingController.appendPage(userListData.dataList!, nextPageKey);
          }
        } else {
          CommonFunctions.showToast(
              "Something went wrong", ToastificationType.error);
        }
      }
    }
    // Handle error in catch
    catch (error) {
      CommonFunctions.showToast(error.toString(), ToastificationType.error);

      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
