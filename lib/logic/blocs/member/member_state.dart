part of 'member_bloc.dart';

abstract class MemberState extends Equatable {
  const MemberState();
  
  @override
  List<Object?> get props => [];
}

// Başlangıç durumu
class MemberInitial extends MemberState {}

// Yükleniyor durumu
class MemberLoading extends MemberState {}

// Üyeler yüklendi durumu
class MembersLoaded extends MemberState {
  final List<Member> members;
  
  const MembersLoaded(this.members);
  
  @override
  List<Object> get props => [members];
}

// Tek üye yüklendi durumu
class MemberLoaded extends MemberState {
  final Member member;
  
  const MemberLoaded(this.member);
  
  @override
  List<Object> get props => [member];
}

// Üye işlemi tamamlandı durumu
class MemberOperationSuccess extends MemberState {
  final String message;
  
  const MemberOperationSuccess(this.message);
  
  @override
  List<Object> get props => [message];
}

// Hata durumu
class MemberError extends MemberState {
  final String message;
  
  const MemberError(this.message);
  
  @override
  List<Object> get props => [message];
}