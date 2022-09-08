
abstract class SocialStates{}
class SocialInitialState extends SocialStates{}
class SocialLoadingState extends SocialStates{}
class SocialSuccessState extends SocialStates{}
class SocialErrorState extends SocialStates{
  String error;
  SocialErrorState({this.error});
}

class HomeNavBarState extends SocialStates{}

class SocialPickProfileSuccessState extends SocialStates{}
class SocialPickProfileErrorState extends SocialStates{}

class SocialPickCoverSuccessState extends SocialStates{}
class SocialPickCoverErrorState extends SocialStates{}

class SocialUploadCoverSuccessState extends SocialStates{}
class SocialUploadCoverErrorState extends SocialStates{}

class SocialUploadProfileSuccessState extends SocialStates{}
class SocialUploadProfileErrorState extends SocialStates{}

class SocialUpdateDataErrorState extends SocialStates{}
class SocialUpdateDataLoadingState extends SocialStates{}

class SocialPickPostImageSuccessState extends SocialStates{}
class SocialPickPostImageErrorState extends SocialStates{}

class SocialRemovePostImageSuccessState extends SocialStates{}

class SocialCreatePostLoadingState extends SocialStates{}
class SocialCreatePostSuccessState extends SocialStates{}
class SocialCreatePostErrorState extends SocialStates{}

class SocialCreatePostForCurrentUserLoadingState extends SocialStates{}
class SocialCreatePostForCurrentUserSuccessState extends SocialStates{}
class SocialCreatePostForCurrentUserErrorState extends SocialStates{}

class SocialCreatePostImageErrorState extends SocialStates{}
class SocialCreatePostImageLoadingState extends SocialStates{}


class SocialGetPostLoadingState extends SocialStates{}
class SocialGetPostSuccessState extends SocialStates{}
class SocialGetPostErrorState extends SocialStates{}

class SocialLikePostSuccessState extends SocialStates{}
class SocialLikePostErrorState extends SocialStates{}

class SocialCommentPostSuccessState extends SocialStates{}
class SocialCommentPostErrorState extends SocialStates{}

class SocialGetAllUserErrorState extends SocialStates{}
class SocialGetAllUserSuccessState extends SocialStates{}

class SocialSendMessageErrorState extends SocialStates{}
class SocialSendMessageSuccessState extends SocialStates{}

class SocialReceiverMessageErrorState extends SocialStates{}
class SocialReceiverMessageSuccessState extends SocialStates{}

class SocialGetMessageSuccessState extends SocialStates{}
class SocialGetCommentSuccessState extends SocialStates{}


class SocialSaveRecorderPathSuccessState extends SocialStates{}
class SocialSaveRecorderPathErrorState extends SocialStates{}


class SocialStopRecorderSuccessState extends SocialStates{}
class SocialStartRecorderSuccessState extends SocialStates{}

class SocialStartRecorderAgainSuccessState extends SocialStates{}

class SocialStopPlayRecorderSuccessState extends SocialStates{}
class SocialStartPlayRecorderSuccessState extends SocialStates{}

class SocialUploadingVoiceLoadingState extends SocialStates{}
class SocialUploadingVoiceSuccessState extends SocialStates{}
class SocialUploadingVoiceFinallyState extends SocialStates{}
class SocialUploadingVoiceErrorState extends SocialStates{}

class SocialPlayVoiceMessageState extends SocialStates{}
class SocialStopVoiceMessageState extends SocialStates{}
class SocialDurationVoiceMessageState extends SocialStates{}
class SocialPositionVoiceMessageState extends SocialStates{}


