//Usage: Navigator.push(context, fadeTransitionPageBuilder(ArtisanHome(),),);
import 'package:flutter/material.dart';

PageRouteBuilder fadeTransitionPageBuilder(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = 0.0;
      const end = 1.0;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var opacityAnimation = animation.drive(tween);

      return FadeTransition(
        opacity: opacityAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 1500),
  );
}

PageRouteBuilder zoomInTransitionPageBuilder(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = 0.0;
      const end = 1.0;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var scaleAnimation = animation.drive(tween);

      return ScaleTransition(
        scale: scaleAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 800),
  );
}

PageRouteBuilder slideLeftTransitionPageBuilder(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 800),
  );
}

// Usage example:
// Navigator.push(context, slideLeftTransitionPageBuilder(ArtisanHome(),),);

PageRouteBuilder slideRightTransitionPageBuilder(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 800),
  );
}



PageRouteBuilder slideTopTransitionPageBuilder(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, -1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 1000),
  );
}

PageRouteBuilder slideBottomTransitionPageBuilder(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 800),
  );
}

PageRouteBuilder zoomTwistTransitionPageBuilder(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // const begin = 0.0;
      // const end = 1.0;
      const curve = Curves.easeInOut;

      var scaleTween =
          Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
      var rotateTween =
          Tween(begin: 0.80, end: 0.0).chain(CurveTween(curve: curve));

      var scaleAnimation = animation.drive(scaleTween);
      var rotateAnimation = animation.drive(rotateTween);

      return Transform.scale(
        scale: scaleAnimation.value,
        child: Transform.rotate(
          angle: rotateAnimation.value * 0.5 * 3.141592653589793,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 800),
  );
}

//This implementation of reading riverpod data with a consumer is superior. It can be used inside a widget tree like inside a column.
// Consumer(
//   builder: (context, ref, child) {
//     final _firebaseAuth = FirebaseAuth.instance;
//     final documentData = ref.watch(
//       riverpodArtisanReviewProvider(widget.artisan.uid),
//     );
//     return documentData.when(
//       data: (_handyArtisanReview) {
//         return FancyReviewBox(
//           artisanID: widget.artisan.uid,
//           initialText: _handyArtisanReview?.review ?? '',
//         );
//       },
//       loading: () => circularProgressLoading(),
//       error: (err, stack) =>
//           SelectableText('Error: \n\n $err'),
//     );
//   },
// ),