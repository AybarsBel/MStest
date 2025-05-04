part of 'member_bloc.dart';

abstract class MemberEvent extends Equatable {
  const MemberEvent();
  
  @override
  List<Object?> get props => [];
}

// Tüm üyeleri yükleme eventi
class LoadAllMembers extends MemberEvent {}

// Duruma göre üyeleri yükleme eventi
class LoadMembersByStatus extends MemberEvent {
  final String status;
  
  const LoadMembersByStatus(this.status);
  
  @override
  List<Object> get props => [status];
}

// Üyeliği yenilenecek üyeleri yükleme eventi
class LoadRenewalMembers extends MemberEvent {}

// Yeni üye ekleme eventi
class AddNewMember extends MemberEvent {
  final Member member;
  final File? profileImage;
  
  const AddNewMember({
    required this.member,
    this.profileImage,
  });
  
  @override
  List<Object?> get props => [member, profileImage];
}

// Üye güncelleme eventi
class UpdateMember extends MemberEvent {
  final Member member;
  final File? profileImage;
  
  const UpdateMember({
    required this.member,
    this.profileImage,
  });
  
  @override
  List<Object?> get props => [member, profileImage];
}

// Üye silme eventi
class DeleteMember extends MemberEvent {
  final String memberId;
  
  const DeleteMember(this.memberId);
  
  @override
  List<Object> get props => [memberId];
}

// Üyeyi pasif yapma eventi
class DeactivateMember extends MemberEvent {
  final String memberId;
  
  const DeactivateMember(this.memberId);
  
  @override
  List<Object> get props => [memberId];
}

// Üyeyi aktif yapma eventi
class ActivateMember extends MemberEvent {
  final String memberId;
  
  const ActivateMember(this.memberId);
  
  @override
  List<Object> get props => [memberId];
}

// Üye arama eventi
class SearchMembers extends MemberEvent {
  final String query;
  
  const SearchMembers(this.query);
  
  @override
  List<Object> get props => [query];
}