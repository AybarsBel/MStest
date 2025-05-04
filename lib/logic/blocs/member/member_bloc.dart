import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/member.dart';
import '../../../data/repositories/member_repository.dart';

// Events
abstract class MemberEvent extends Equatable {
  const MemberEvent();

  @override
  List<Object> get props => [];
}

class LoadAllMembers extends MemberEvent {}

class LoadMemberById extends MemberEvent {
  final String memberId;

  const LoadMemberById(this.memberId);

  @override
  List<Object> get props => [memberId];
}

class LoadActiveMembers extends MemberEvent {}

class LoadInactiveMembers extends MemberEvent {}

class LoadRenewalMembers extends MemberEvent {}

class AddMember extends MemberEvent {
  final Member member;

  const AddMember(this.member);

  @override
  List<Object> get props => [member];
}

class UpdateMember extends MemberEvent {
  final Member member;

  const UpdateMember(this.member);

  @override
  List<Object> get props => [member];
}

class DeleteMember extends MemberEvent {
  final String memberId;

  const DeleteMember(this.memberId);

  @override
  List<Object> get props => [memberId];
}

class SearchMembers extends MemberEvent {
  final String query;

  const SearchMembers(this.query);

  @override
  List<Object> get props => [query];
}

// States
abstract class MemberState extends Equatable {
  const MemberState();

  @override
  List<Object> get props => [];
}

class MemberInitial extends MemberState {}

class MemberLoading extends MemberState {}

class MembersLoaded extends MemberState {
  final List<Member> members;
  final bool isFiltered;

  const MembersLoaded(this.members, {this.isFiltered = false});

  @override
  List<Object> get props => [members, isFiltered];
}

class MemberLoaded extends MemberState {
  final Member member;

  const MemberLoaded(this.member);

  @override
  List<Object> get props => [member];
}

class MemberError extends MemberState {
  final String message;

  const MemberError(this.message);

  @override
  List<Object> get props => [message];
}

class MemberAdded extends MemberState {
  final Member member;

  const MemberAdded(this.member);

  @override
  List<Object> get props => [member];
}

class MemberUpdated extends MemberState {
  final Member member;

  const MemberUpdated(this.member);

  @override
  List<Object> get props => [member];
}

class MemberDeleted extends MemberState {
  final String memberId;

  const MemberDeleted(this.memberId);

  @override
  List<Object> get props => [memberId];
}

// BLoC
class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final MemberRepository memberRepository;

  MemberBloc({required this.memberRepository}) : super(MemberInitial()) {
    on<LoadAllMembers>(_onLoadAllMembers);
    on<LoadMemberById>(_onLoadMemberById);
    on<LoadActiveMembers>(_onLoadActiveMembers);
    on<LoadInactiveMembers>(_onLoadInactiveMembers);
    on<LoadRenewalMembers>(_onLoadRenewalMembers);
    on<AddMember>(_onAddMember);
    on<UpdateMember>(_onUpdateMember);
    on<DeleteMember>(_onDeleteMember);
    on<SearchMembers>(_onSearchMembers);
  }

  void _onLoadAllMembers(LoadAllMembers event, Emitter<MemberState> emit) async {
    emit(MemberLoading());
    try {
      final members = await memberRepository.getAllMembers();
      emit(MembersLoaded(members));
    } catch (e) {
      emit(MemberError('Üyeler yüklenirken bir hata oluştu: $e'));
    }
  }

  void _onLoadMemberById(LoadMemberById event, Emitter<MemberState> emit) async {
    emit(MemberLoading());
    try {
      final member = await memberRepository.getMemberById(event.memberId);
      if (member != null) {
        emit(MemberLoaded(member));
      } else {
        emit(const MemberError('Üye bulunamadı.'));
      }
    } catch (e) {
      emit(MemberError('Üye yüklenirken bir hata oluştu: $e'));
    }
  }

  void _onLoadActiveMembers(LoadActiveMembers event, Emitter<MemberState> emit) async {
    emit(MemberLoading());
    try {
      final members = await memberRepository.getActiveMembers();
      emit(MembersLoaded(members, isFiltered: true));
    } catch (e) {
      emit(MemberError('Aktif üyeler yüklenirken bir hata oluştu: $e'));
    }
  }

  void _onLoadInactiveMembers(LoadInactiveMembers event, Emitter<MemberState> emit) async {
    emit(MemberLoading());
    try {
      final members = await memberRepository.getInactiveMembers();
      emit(MembersLoaded(members, isFiltered: true));
    } catch (e) {
      emit(MemberError('Pasif üyeler yüklenirken bir hata oluştu: $e'));
    }
  }

  void _onLoadRenewalMembers(LoadRenewalMembers event, Emitter<MemberState> emit) async {
    emit(MemberLoading());
    try {
      final members = await memberRepository.getMembersWithExpiringMembership();
      emit(MembersLoaded(members, isFiltered: true));
    } catch (e) {
      emit(MemberError('Yenileme gereken üyeler yüklenirken bir hata oluştu: $e'));
    }
  }

  void _onAddMember(AddMember event, Emitter<MemberState> emit) async {
    emit(MemberLoading());
    try {
      final success = await memberRepository.addMember(event.member);
      if (success) {
        emit(MemberAdded(event.member));
        // Listeyi yeniden yükle
        add(LoadAllMembers());
      } else {
        emit(const MemberError('Üye eklenemedi.'));
      }
    } catch (e) {
      emit(MemberError('Üye eklenirken bir hata oluştu: $e'));
    }
  }

  void _onUpdateMember(UpdateMember event, Emitter<MemberState> emit) async {
    emit(MemberLoading());
    try {
      final success = await memberRepository.updateMember(event.member);
      if (success) {
        emit(MemberUpdated(event.member));
        // Listeyi yeniden yükle
        add(LoadAllMembers());
      } else {
        emit(const MemberError('Üye güncellenemedi.'));
      }
    } catch (e) {
      emit(MemberError('Üye güncellenirken bir hata oluştu: $e'));
    }
  }

  void _onDeleteMember(DeleteMember event, Emitter<MemberState> emit) async {
    emit(MemberLoading());
    try {
      final success = await memberRepository.deleteMember(event.memberId);
      if (success) {
        emit(MemberDeleted(event.memberId));
        // Listeyi yeniden yükle
        add(LoadAllMembers());
      } else {
        emit(const MemberError('Üye silinemedi.'));
      }
    } catch (e) {
      emit(MemberError('Üye silinirken bir hata oluştu: $e'));
    }
  }

  void _onSearchMembers(SearchMembers event, Emitter<MemberState> emit) async {
    if (event.query.isEmpty) {
      add(LoadAllMembers());
      return;
    }

    emit(MemberLoading());
    try {
      final members = await memberRepository.searchMembersByName(event.query);
      emit(MembersLoaded(members, isFiltered: true));
    } catch (e) {
      emit(MemberError('Üye araması yapılırken bir hata oluştu: $e'));
    }
  }
}