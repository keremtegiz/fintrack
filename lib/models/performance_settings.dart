import 'package:flutter/foundation.dart';

class PerformanceSettings {
  final bool useGPU;
  final bool useMultithreading;
  final int maxThreads;
  final bool useCache;
  final int cacheSize;
  final String cacheDuration;
  final bool useCompression;
  final String compressionLevel;
  final bool useLazyLoading;
  final int batchSize;
  final bool usePagination;
  final int pageSize;
  final bool useVirtualization;
  final bool useRecycling;
  final bool usePrefetching;
  final int prefetchCount;
  final bool useBackgroundProcessing;
  final String processingPriority; // 'low', 'medium', 'high'
  final bool useMemoryOptimization;
  final int maxMemoryUsage;
  final bool useDiskCache;
  final String diskCachePath;
  final int diskCacheSize;
  final String diskCacheDuration;

  PerformanceSettings({
    this.useGPU = true,
    this.useMultithreading = true,
    this.maxThreads = 4,
    this.useCache = true,
    this.cacheSize = 100,
    this.cacheDuration = '1h',
    this.useCompression = true,
    this.compressionLevel = 'medium',
    this.useLazyLoading = true,
    this.batchSize = 20,
    this.usePagination = true,
    this.pageSize = 10,
    this.useVirtualization = true,
    this.useRecycling = true,
    this.usePrefetching = true,
    this.prefetchCount = 5,
    this.useBackgroundProcessing = true,
    this.processingPriority = 'medium',
    this.useMemoryOptimization = true,
    this.maxMemoryUsage = 500,
    this.useDiskCache = true,
    this.diskCachePath = 'cache/',
    this.diskCacheSize = 1000,
    this.diskCacheDuration = '1d',
  });

  Map<String, dynamic> toJson() {
    return {
      'useGPU': useGPU,
      'useMultithreading': useMultithreading,
      'maxThreads': maxThreads,
      'useCache': useCache,
      'cacheSize': cacheSize,
      'cacheDuration': cacheDuration,
      'useCompression': useCompression,
      'compressionLevel': compressionLevel,
      'useLazyLoading': useLazyLoading,
      'batchSize': batchSize,
      'usePagination': usePagination,
      'pageSize': pageSize,
      'useVirtualization': useVirtualization,
      'useRecycling': useRecycling,
      'usePrefetching': usePrefetching,
      'prefetchCount': prefetchCount,
      'useBackgroundProcessing': useBackgroundProcessing,
      'processingPriority': processingPriority,
      'useMemoryOptimization': useMemoryOptimization,
      'maxMemoryUsage': maxMemoryUsage,
      'useDiskCache': useDiskCache,
      'diskCachePath': diskCachePath,
      'diskCacheSize': diskCacheSize,
      'diskCacheDuration': diskCacheDuration,
    };
  }

  factory PerformanceSettings.fromJson(Map<String, dynamic> json) {
    return PerformanceSettings(
      useGPU: json['useGPU'],
      useMultithreading: json['useMultithreading'],
      maxThreads: json['maxThreads'],
      useCache: json['useCache'],
      cacheSize: json['cacheSize'],
      cacheDuration: json['cacheDuration'],
      useCompression: json['useCompression'],
      compressionLevel: json['compressionLevel'],
      useLazyLoading: json['useLazyLoading'],
      batchSize: json['batchSize'],
      usePagination: json['usePagination'],
      pageSize: json['pageSize'],
      useVirtualization: json['useVirtualization'],
      useRecycling: json['useRecycling'],
      usePrefetching: json['usePrefetching'],
      prefetchCount: json['prefetchCount'],
      useBackgroundProcessing: json['useBackgroundProcessing'],
      processingPriority: json['processingPriority'],
      useMemoryOptimization: json['useMemoryOptimization'],
      maxMemoryUsage: json['maxMemoryUsage'],
      useDiskCache: json['useDiskCache'],
      diskCachePath: json['diskCachePath'],
      diskCacheSize: json['diskCacheSize'],
      diskCacheDuration: json['diskCacheDuration'],
    );
  }
} 