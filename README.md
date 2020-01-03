# state_layout

A new Flutter project.

## how to use

![state](./doc/state.gif)

```dart
  
  StateLayout<int>(
        future: _fetchData,
        builder: (count) {
          // the view to show
        })

  // network
  Future<int> _fetchData() async {
    await Future.delayed(Duration(seconds: 2));
    return 1;
  }
```


