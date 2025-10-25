// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'readiness_gate_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State notifier that tracks Nostr service initialization status
/// Provides reactive updates when initialization state changes

@ProviderFor(NostrInitialization)
const nostrInitializationProvider = NostrInitializationProvider._();

/// State notifier that tracks Nostr service initialization status
/// Provides reactive updates when initialization state changes
final class NostrInitializationProvider
    extends $NotifierProvider<NostrInitialization, bool> {
  /// State notifier that tracks Nostr service initialization status
  /// Provides reactive updates when initialization state changes
  const NostrInitializationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nostrInitializationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nostrInitializationHash();

  @$internal
  @override
  NostrInitialization create() => NostrInitialization();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$nostrInitializationHash() =>
    r'e40e826b65db307d943b6a6e90e28685f63280d0';

/// State notifier that tracks Nostr service initialization status
/// Provides reactive updates when initialization state changes

abstract class _$NostrInitialization extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider that checks if Nostr service is fully initialized and ready for subscriptions

@ProviderFor(nostrReady)
const nostrReadyProvider = NostrReadyProvider._();

/// Provider that checks if Nostr service is fully initialized and ready for subscriptions

final class NostrReadyProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider that checks if Nostr service is fully initialized and ready for subscriptions
  const NostrReadyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nostrReadyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nostrReadyHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return nostrReady(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$nostrReadyHash() => r'bea339fd01394d452e936f7a419d04c118f5c1ea';

/// Provider that combines all readiness gates to determine if app is ready for subscriptions

@ProviderFor(appReady)
const appReadyProvider = AppReadyProvider._();

/// Provider that combines all readiness gates to determine if app is ready for subscriptions

final class AppReadyProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider that combines all readiness gates to determine if app is ready for subscriptions
  const AppReadyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appReadyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appReadyHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return appReady(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$appReadyHash() => r'883600dbc8e138ca825a2b8ab49f079b0d4a5325';

/// Provider that checks if the discovery/explore tab is currently active

@ProviderFor(isDiscoveryTabActive)
const isDiscoveryTabActiveProvider = IsDiscoveryTabActiveProvider._();

/// Provider that checks if the discovery/explore tab is currently active

final class IsDiscoveryTabActiveProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider that checks if the discovery/explore tab is currently active
  const IsDiscoveryTabActiveProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isDiscoveryTabActiveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isDiscoveryTabActiveHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isDiscoveryTabActive(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isDiscoveryTabActiveHash() =>
    r'65a27a8efdc1f02b884368872ebc4978fabf0044';
