// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$messagesViewModelHash() => r'7c84296434b3cfd22975500945e863b6c458f694';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$MessagesViewModel
    extends BuildlessAutoDisposeStreamNotifier<List<Message>> {
  late final String contactUID;

  Stream<List<Message>> build(String contactUID);
}

/// See also [MessagesViewModel].
@ProviderFor(MessagesViewModel)
const messagesViewModelProvider = MessagesViewModelFamily();

/// See also [MessagesViewModel].
class MessagesViewModelFamily extends Family<AsyncValue<List<Message>>> {
  /// See also [MessagesViewModel].
  const MessagesViewModelFamily();

  /// See also [MessagesViewModel].
  MessagesViewModelProvider call(String contactUID) {
    return MessagesViewModelProvider(contactUID);
  }

  @override
  MessagesViewModelProvider getProviderOverride(
    covariant MessagesViewModelProvider provider,
  ) {
    return call(provider.contactUID);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'messagesViewModelProvider';
}

/// See also [MessagesViewModel].
class MessagesViewModelProvider
    extends
        AutoDisposeStreamNotifierProviderImpl<
          MessagesViewModel,
          List<Message>
        > {
  /// See also [MessagesViewModel].
  MessagesViewModelProvider(String contactUID)
    : this._internal(
        () => MessagesViewModel()..contactUID = contactUID,
        from: messagesViewModelProvider,
        name: r'messagesViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$messagesViewModelHash,
        dependencies: MessagesViewModelFamily._dependencies,
        allTransitiveDependencies:
            MessagesViewModelFamily._allTransitiveDependencies,
        contactUID: contactUID,
      );

  MessagesViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.contactUID,
  }) : super.internal();

  final String contactUID;

  @override
  Stream<List<Message>> runNotifierBuild(covariant MessagesViewModel notifier) {
    return notifier.build(contactUID);
  }

  @override
  Override overrideWith(MessagesViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: MessagesViewModelProvider._internal(
        () => create()..contactUID = contactUID,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        contactUID: contactUID,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<MessagesViewModel, List<Message>>
  createElement() {
    return _MessagesViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MessagesViewModelProvider && other.contactUID == contactUID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, contactUID.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MessagesViewModelRef
    on AutoDisposeStreamNotifierProviderRef<List<Message>> {
  /// The parameter `contactUID` of this provider.
  String get contactUID;
}

class _MessagesViewModelProviderElement
    extends
        AutoDisposeStreamNotifierProviderElement<
          MessagesViewModel,
          List<Message>
        >
    with MessagesViewModelRef {
  _MessagesViewModelProviderElement(super.provider);

  @override
  String get contactUID => (origin as MessagesViewModelProvider).contactUID;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
