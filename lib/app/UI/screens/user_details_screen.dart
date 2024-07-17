import 'package:assesment1/app/UI/widgets/text_animate_widget.dart';
import 'package:assesment1/app/app_styles/style.dart';
import 'package:assesment1/app/state_management/user_cubit.dart';
import 'package:assesment1/app/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class UserDetailsScreen extends StatefulWidget {
  final int? userId;

  const UserDetailsScreen({super.key, this.userId});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen>
    with SingleTickerProviderStateMixin {
  late Future<User> futureUser;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    readData();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text(state.userDetailState != null
                  ? state.userDetailState!.user!.firstName ?? ""
                  : ""),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: context.read<UserCubit>().getUserDataLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : UserCard(
                      user: state.userDetailState!.user!,
                      animation: _animation),
            ));
      },
    );
  }

  Future<void> readData() async {
    try {
      await context.read<UserCubit>().fetchUserData(widget.userId!);
      if (mounted) {
        if (context.read<UserCubit>().responseStatusCode != 200) {
          CommonFunctions.showToast(
              "Something went wrong", ToastificationType.error);
        }
      }
    } catch (err) {
      CommonFunctions.showToast(err.toString(), ToastificationType.error);
      rethrow;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class UserCard extends StatelessWidget {
  final User user;
  final Animation<double> animation;

  const UserCard({
    super.key,
    required this.user,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(18.0),
          height: 250,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  _gotoDetailsPage(context, user.profileUrl!);
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    user.profileUrl!,
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    const Icon(Icons.insert_emoticon),
                    const SizedBox(width: 10),
                    TextAnimateWidget(
                      textStyle: Style.nameTextStyle,
                      restingEffects: WidgetRestingEffects.dangle(),
                      textValue: '${user.firstName} ${user.lastName}',
                      effects:
                          WidgetTransitionEffects.incomingSlideInFromBottom(
                        curve: Curves.bounceOut,
                        duration: const Duration(milliseconds: 1500),
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    const Icon(Icons.email),
                    const SizedBox(width: 10),
                    TextAnimateWidget(
                      textStyle: Style.emailStyle,
                      textValue: user.email!,
                      restingEffects: WidgetRestingEffects.dangle(),
                      effects: WidgetTransitionEffects.incomingScaleDown(
                        duration: const Duration(milliseconds: 1500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _gotoDetailsPage(BuildContext context, String url) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) => Scaffold(
        body: Center(
          child: Hero(
            tag: 'hero-rectangle',
            child: BoxWidget(size: const Size(300.0, 300.0), url: url),
          ),
        ),
      ),
    ));
  }
}

class BoxWidget extends StatelessWidget {
  final String? url;

  const BoxWidget({
    super.key,
    required this.size,
    this.url,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Column(
        children: [
          Image.network(url!),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Click me to back"))
        ],
      ),
    );
  }
}
