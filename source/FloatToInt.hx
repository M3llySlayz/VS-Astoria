import haxe.Timer.stamp;

// Testing float to integer conversion faster than Std.int() for C++ based on: 
// http://stackoverflow.com/questions/429632/how-to-speed-up-floating-point-to-integer-number-conversion
class FloatToInt {

#if cpp
   @:functionCode("
   union Cast
   {
      double d;
      long l;
   };
   volatile Cast c;
   // -0 is round
   // -0.5 is floor
   // Don't combine these constants, it doesn't work
   c.d = (f-0.5) + 6755399441055744.0;
   return c.l;
	")
  // Don't use inline here, breaks @:functionCode
  static function fastInt(f:Float):Int {
    return 0;
  }
#else
  public static inline function fastInt(f:Float):Int {
    return Std.int(f);
  }
#end

  static function main() {
    var sum:Int = 0;
    var t0:Float = stamp();
    var floats:Array<Float> = [];

    trace('Generating floats...');
    for (i in 0...10000000) {
      floats.push(i/1023.7);
    }

    var len = 100000000;

    // reset caches
    sum = 0;
    for (i in 0...len) { sum = sum + Std.int(floats[i % 10000000]); }

    trace('Testing...');
    sum = 0;
    t0 = stamp();
    for (i in 0...len) {
      sum = sum + Std.int(floats[i % 10000000]);
    }
    trace(" Std.int: "+(stamp()-t0)+", sum="+sum);

    // reset caches
    sum = 0;
    for (i in 0...len) { sum = sum + Std.int(floats[i % 10000000]); }

    sum = 0;
    t0 = stamp();
    for (i in 0...len) {
      sum = sum + fastInt(floats[i % 10000000]);
    }
    trace(" fastInt: "+(stamp()-t0)+", sum="+sum);

    // reset caches
    sum = 0;
    for (i in 0...len) { sum = sum + Std.int(floats[i % 10000000]); }

    sum = 0;
    t0 = stamp();
    for (i in 0...len) {
      untyped __cpp__('sum = sum + (floats[i%10000000])/1;');
    }
    trace("__cpp1__: "+(stamp()-t0)+", sum="+sum);

    // reset caches
    sum = 0;
    for (i in 0...len) { sum = sum + Std.int(floats[i % 10000000]); }

    sum = 0;
    t0 = stamp();
    var n:Int = 0;
    for (i in 0...len) {
      var f:Float = floats[i%10000000];
      untyped __cpp__('n = floats[i%10000000]/1;');
      sum = sum + n;
    }
    trace("__cpp2__: "+(stamp()-t0)+", sum="+sum);
  }
}