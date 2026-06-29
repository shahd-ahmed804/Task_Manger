class OnBoardingData {
  String title;
  String describtion;
  String image;
  OnBoardingData({
    required this.title,
    required this.image,
    required this.describtion,
  });
}

List<OnBoardingData> dataOnBoarding() {
  return [
    OnBoardingData(
      title: 'Manage your tasks',
      image: 'assets/images/on_boarding1.png',
      describtion:
          'You can easily manage all of your daily tasks in DoMe for free',
    ),
    OnBoardingData(
      title: 'Create daily routine',
      image: 'assets/images/on_boarding2.png',
      describtion:
          'In Tasky  you can create your personalized routine to stay productive',
    ),
    OnBoardingData(
      title: 'Orgonaize your tasks',
      image: 'assets/images/on_boarding3.png',
      describtion:
          'You can organize your daily tasks by adding your tasks into separate categories',
    ),
  ];
}
