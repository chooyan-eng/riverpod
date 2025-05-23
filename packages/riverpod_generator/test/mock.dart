import 'package:mockito/mockito.dart';
import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/experimental/mutation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

TypeMatcher<ProviderException> isProviderException(
  Object exception, [
  Object? stackTrace,
]) {
  var matcher = isA<ProviderException>();
  matcher = matcher.having((e) => e.exception, 'exception', exception);
  if (stackTrace != null) {
    matcher = matcher.having((e) => e.stackTrace, 'stackTrace', stackTrace);
  }

  return matcher;
}

Matcher throwsProviderException(Object exception, [Object? stackTrace]) {
  return throwsA(isProviderException(exception, stackTrace));
}

class ListenerMock<T> with Mock {
  void call(Object? a, Object? b);
}

typedef VerifyOnly = VerificationResult Function<T>(
  Mock mock,
  T matchingInvocations,
);

/// Syntax sugar for:
///
/// ```dart
/// verify(mock()).called(1);
/// verifyNoMoreInteractions(mock);
/// ```
VerifyOnly get verifyOnly {
  final verification = verify;

  return <T>(mock, invocation) {
    final result = verification(invocation);
    result.called(1);
    verifyNoMoreInteractions(mock);
    return result;
  };
}

TypeMatcher<MutationBase<T>> isMutationBase<T>({
  TypeMatcher<MutationState<T>>? state,
}) {
  var matcher = isA<MutationBase<T>>();

  if (state != null) {
    matcher = matcher.having((e) => e.state, 'state', state);
  }

  return matcher;
}

TypeMatcher<MutationIdle<T>> isMutationIdle<T>() {
  return isA<MutationIdle<T>>();
}

TypeMatcher<MutationPending<T>> isMutationPending<T>() {
  return isA<MutationPending<T>>();
}

TypeMatcher<MutationSuccess<T>> isMutationSuccess<T>(T value) {
  return isA<MutationSuccess<T>>().having((e) => e.value, 'value', value);
}

TypeMatcher<MutationError<T>> isMutationError<T>(Object error) {
  return isA<MutationError<T>>().having((e) => e.error, 'error', error);
}

enum InvocationKind {
  method,
  getter,
  setter,
}

TypeMatcher<Invocation> isInvocation({
  Object? memberName,
  List<Object?>? positionalArguments,
  Map<Symbol, Object?>? namedArguments,
  Object? typeArguments,
  InvocationKind? kind,
}) {
  var matcher = isA<Invocation>();

  if (kind != null) {
    switch (kind) {
      case InvocationKind.method:
        matcher = matcher.having((e) => e.isMethod, 'isMethod', true);
      case InvocationKind.getter:
        matcher = matcher.having((e) => e.isGetter, 'isGetter', true);
      case InvocationKind.setter:
        matcher = matcher.having((e) => e.isSetter, 'isSetter', true);
    }
  }

  if (typeArguments != null) {
    matcher = matcher.having(
      (e) => e.typeArguments,
      'typeArguments',
      typeArguments,
    );
  }

  if (memberName != null) {
    matcher = matcher.having((e) => e.memberName, 'memberName', memberName);
  }

  if (positionalArguments != null) {
    matcher = matcher.having(
      (e) => e.positionalArguments,
      'positionalArguments',
      positionalArguments,
    );
  }

  if (namedArguments != null) {
    matcher = matcher.having(
      (e) => e.namedArguments,
      'namedArguments',
      namedArguments,
    );
  }

  return matcher;
}

class ObserverMock extends Mock implements ProviderObserver {
  ObserverMock([this.label]);

  final String? label;

  @override
  String toString() {
    return label ?? super.toString();
  }

  @override
  void didAddProvider(
    ProviderObserverContext? context,
    Object? value,
  );

  @override
  void providerDidFail(
    ProviderObserverContext? context,
    Object? error,
    StackTrace? stackTrace,
  );

  @override
  void didUpdateProvider(
    ProviderObserverContext? context,
    Object? previousValue,
    Object? newValue,
  );

  @override
  void didDisposeProvider(ProviderObserverContext? context);

  @override
  void mutationReset(ProviderObserverContext? context);

  @override
  void mutationStart(
    ProviderObserverContext? context,
    MutationContext? mutation,
  );

  @override
  void mutationError(
    ProviderObserverContext? context,
    MutationContext? mutation,
    Object? error,
    StackTrace? stackTrace,
  );

  @override
  void mutationSuccess(
    ProviderObserverContext? context,
    MutationContext? mutation,
    Object? result,
  );
}

TypeMatcher<ProviderObserverContext> isProviderObserverContext(
  ProviderBase<Object?> provider,
  ProviderContainer container, {
  required Object? mutation,
}) {
  var matcher = isA<ProviderObserverContext>();

  matcher = matcher.having((e) => e.provider, 'provider', provider);
  matcher = matcher.having((e) => e.container, 'container', container);
  matcher = matcher.having((e) => e.mutation, 'mutation', mutation);
  if (provider is $ClassProvider) {
    matcher = matcher.having(
      (e) => e.notifier,
      'notifier',
      container.read(provider.notifier),
    );
  }

  return matcher;
}

TypeMatcher<MutationContext> isMutationContext(Object? invocation) {
  return isA<MutationContext>()
      .having((e) => e.invocation, 'invocation', invocation);
}
