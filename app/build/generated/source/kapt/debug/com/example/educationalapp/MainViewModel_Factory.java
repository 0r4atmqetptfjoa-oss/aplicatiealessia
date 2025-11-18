package com.example.educationalapp;

import android.app.Application;
import dagger.internal.DaggerGenerated;
import dagger.internal.Factory;
import dagger.internal.QualifierMetadata;
import dagger.internal.ScopeMetadata;
import javax.annotation.processing.Generated;
import javax.inject.Provider;

@ScopeMetadata
@QualifierMetadata
@DaggerGenerated
@Generated(
    value = "dagger.internal.codegen.ComponentProcessor",
    comments = "https://dagger.dev"
)
@SuppressWarnings({
    "unchecked",
    "rawtypes",
    "KotlinInternal",
    "KotlinInternalInJava",
    "cast"
})
public final class MainViewModel_Factory implements Factory<MainViewModel> {
  private final Provider<Application> applicationProvider;

  public MainViewModel_Factory(Provider<Application> applicationProvider) {
    this.applicationProvider = applicationProvider;
  }

  @Override
  public MainViewModel get() {
    return newInstance(applicationProvider.get());
  }

  public static MainViewModel_Factory create(Provider<Application> applicationProvider) {
    return new MainViewModel_Factory(applicationProvider);
  }

  public static MainViewModel newInstance(Application application) {
    return new MainViewModel(application);
  }
}
