/**
 * Shuffles the elements of an array in-place. This function has linear
 * complexity.
 *
 * @param a An array of arbitrary elements.
 *
 * @return Nothing; the given array is sorted in-place.
 */
function shuffleArray(a) {
    var len = a.length;
    if (len == 0)
        return;

    for ( var i = len - 1; i >= 1; --i ) {
        var j = Math.floor(Math.random() * i);
        var tmp = a[i];
        a[i] = a[j];
        a[j] = tmp;
    }
}

/**
 * Recursively enumerates objects in the application, calling a custom
 * function for each object seen.
 *
 * @param callback A function which is called for each object seen during
 * the traversal. This function should take one argument, an object.
 * @param parentObject This optional parameter can be given to restrict the
 * traversal to just a part of the object hierarchy. If this parameter is
 * given, it should be an object so that only descendants of this object
 * are visited.
 */
function enumerateObjects(callback, parentObject) {
    var objects = [];
    if (!parentObject) {
        objects = object.topLevelObjects();
    } else {
        objects = object.children(parentObject);
    }

    for (var i in objects) {
        var o = objects[i];
        if (callback(o)) {
            enumerateObjects(callback, o);
        }
    }
}

/**
 * Generates a random string.
 *
 * @param len Requested length for the string to be generated.
 *
 * @return A string of the specificied length, consisting of random characters.
 */
function makeRandomString(len)
{
    var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";

    var result = "";
    for (var i = 0; i < len; ++i) {
        result += chars[Math.floor(Math.random() * chars.length)];
    }
    return result;
}
