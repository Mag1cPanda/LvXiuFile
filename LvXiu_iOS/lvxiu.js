var Base64 = {

    // private property
    _keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",

    // public method for encoding
    encode : function (input) {
        var output = "";
        var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
        var i = 0;
        input = this._utf8_encode(input);
        while (i < input.length) {
            chr1 = input.charCodeAt(i++);
            chr2 = input.charCodeAt(i++);
            chr3 = input.charCodeAt(i++);
            enc1 = chr1 >> 2;
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
            enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
            enc4 = chr3 & 63;
            if (isNaN(chr2)) {
                enc3 = enc4 = 64;
            } else if (isNaN(chr3)) {
                enc4 = 64;
            }
            output = output +
            this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) +
            this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);
        }
        return output;
    },

    // public method for decoding
    decode : function (input) {
        var output = "";
        var chr1, chr2, chr3;
        var enc1, enc2, enc3, enc4;
        var i = 0;
        input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
        while (i < input.length) {
            enc1 = this._keyStr.indexOf(input.charAt(i++));
            enc2 = this._keyStr.indexOf(input.charAt(i++));
            enc3 = this._keyStr.indexOf(input.charAt(i++));
            enc4 = this._keyStr.indexOf(input.charAt(i++));
            chr1 = (enc1 << 2) | (enc2 >> 4);
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
            chr3 = ((enc3 & 3) << 6) | enc4;
            output = output + String.fromCharCode(chr1);
            if (enc3 != 64) {
                output = output + String.fromCharCode(chr2);
            }
            if (enc4 != 64) {
                output = output + String.fromCharCode(chr3);
            }
        }
        output = this._utf8_decode(output);
        return output;
    },

    // private method for UTF-8 encoding
    _utf8_encode : function (string) {
        string = string.replace(/\r\n/g,"\n");
        var utftext = "";
        for (var n = 0; n < string.length; n++) {
            var c = string.charCodeAt(n);
            if (c < 128) {
                utftext += String.fromCharCode(c);
            } else if((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            } else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }

        }
        return utftext;
    },

    // private method for UTF-8 decoding
    _utf8_decode : function (utftext) {
        var string = "";
        var i = 0;
        var c = c1 = c2 = 0;
        while ( i < utftext.length ) {
            c = utftext.charCodeAt(i);
            if (c < 128) {
                string += String.fromCharCode(c);
                i++;
            } else if((c > 191) && (c < 224)) {
                c2 = utftext.charCodeAt(i+1);
                string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                i += 2;
            } else {
                c2 = utftext.charCodeAt(i+1);
                c3 = utftext.charCodeAt(i+2);
                string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                i += 3;
            }
        }
        return string;
    },
}
var lxBridge = {
    callbacks: {},
    getParams: function(params){
        var paramsIn = '{}';
        if(null !== params)
        {
            if('object' === typeof params)
            {
                paramsIn = JSON.stringify(params);
            }
            else
            {
                paramsIn = params;
            }
        }
        return paramsIn;
    },
    call: function(methodName, params, callbacks, removeAfterRun){
        var guid = lvxiu.call(methodName, this.getParams(params), void 0 === removeAfterRun ? true : removeAfterRun);
        if('string' === typeof guid)
        {
            this.callbacks[guid] = callbacks;
            lvxiu.execAsync(guid);
        }
        return guid;
    },
    callObject: function(methodName, params){
        return lvxiu.callObject(methodName, this.getParams(params));
    },
    callStr: function(methodName, params){
        return lvxiu.callStr(methodName, this.getParams(params));
    },
    callInt: function(methodName, params){
        return lvxiu.callInt(methodName, this.getParams(params));
    },
    callDouble: function(methodName, params){
        return lvxiu.callDouble(methodName, this.getParams(params));
    },
    receiveAsync: function(id, eventName, data){
        if(void 0 !== this.callbacks[id] && void 0 !== this.callbacks[id][eventName])
        {
            this.callbacks[id][eventName].apply(null, [JSON.parse(Base64.decode(data))]);
        }
    },
};
var lx = {
    chooseImage: function(params){
        lxBridge.call('lvxiu.chooseImage', params, {
            success: void 0 === params.success ? null : params.success
        });
    },
    getImage: function(fileID){
        return lxBridge.callStr('lvxiu.getImage', fileID);
    },
    getImageExif: function(fileID){
        return JSON.parse(lxBridge.callStr('lvxiu.getImageExif', fileID));
    },
    parseApiUrl: function(url){
        if(lxVersion.isApp())
        {
            return lxBridge.callStr('lvxiu.parseApiUrl', url);
        }
        else if('lvxiu.96007.cc' === location.hostname)
        {
            return 'https://lvxiu.96007.cc/' + url;
        }
        else
        {
            return 'http://test.lvxiu.96007.cc/' + url;
        }
    },
    openWindow: function(url){
        return lxBridge.callStr('lvxiu.openWindow', url);
    },
    openWindowWithData: function(option){
        var _option = JSON.parse(JSON.stringify(option));
        if(void 0 == _option.data)
        {
            _option.data = "{}";
        }
        else
        {
            _option.data = JSON.stringify(_option.data);
        }
        return lxBridge.callStr('lvxiu.openWindowWithData', JSON.stringify(_option));
    },
    closeWindow: function(){
        return lxBridge.callStr('lvxiu.closeWindow', '');
    },
    getWindowData: function(){
        return JSON.parse(lxBridge.callStr('lvxiu.getWindowData', ""));
    },
    setActionBar: function(option){
        var callbacks = {};
        if(void 0 !== option['menus'])
        {
            for(var key in option.menus)
            {
                if(void 0 !== option.menus[key]['title'])
                {
                    if(void 0 !== option.menus[key]['callback'])
                    {
                        callbacks['menu' + key] = option.menus[key].callback;
                    }
                }
            }
        }
        if(void 0 !== option['titleClick'])
        {
            callbacks['titleClick'] = option['titleClick'];
        }
        callbacks['returnButtonClick'] = function(){
            if(void 0 === option['returnButtonClick'])
            {
                lx.closeWindow();
            }
            else
            {
                if(option['returnButtonClick']())
                {
                    lx.closeWindow();
                }
            }
        };
        if(void 0 !== option['rightButtonClick'])
        {
            callbacks['rightButtonClick'] = option['rightButtonClick'];
        }
        var guid = lxBridge.call('lvxiu.setActionBar', option, callbacks, false);
        lxBridge.callStr('lvxiu.setActionBarGUID', guid);
    },
    setWindowEvent: function(option){
        var callbacks = {};
        if(void 0 !== option['resume'])
        {
            callbacks['resume'] = option['resume'];
        }
        callbacks['close'] = function(){
            if(void 0 === option['close'])
            {
                lx.closeWindow();
            }
            else
            {
                if(option['close']())
                {
                    lx.closeWindow();
                }
            }
        };
        var guid = lxBridge.call('lvxiu.setWindowEvent', option, callbacks, false);
        lxBridge.callStr('lvxiu.setWindowGUID', guid);
    },
    getLocation: function(params){
        if (navigator.geolocation)
        {
            navigator.geolocation.getCurrentPosition(function(position){
                if(void 0 === params.success)
                {
                    params.success({
                        success: true,
                        latitude: position.coords.latitude,
                        longitude: position.coords.longitude,
                    });
                }
            }, function(err){
                if(lxVersion.isApp())
                {
                    lx.getLocationFromNative(params);
                }
                else if(void 0 === params.error)
                {
                    params.error({
                        success: false,
                        latitude: 0,
                        longitude: 0,
                    });
                }
            });
        }
        else if(lxVersion.isApp())
        {
            this.getLocationFromNative(params);
        }
    },
    getLocationFromNative: function(params){
        lxBridge.call('lvxiu.getLocation', params, {
            success: void 0 === params.success ? null : params.success,
            error: void 0 === params.error ? null : params.error,
        });
    },
    hapticFeedback: function(){
        return lxBridge.callStr('lvxiu.hapticFeedback', "");
    },
    getDeviceID: function(){
        return lxBridge.callStr('lvxiu.getDeviceID', "");
    },
};
var lxOAuth = {
    setToken: function(params){
        lxBridge.callObject('OAuth.setToken', params);
    },
    qq: function(params){
        lxBridge.call('OAuth.qq', null, {
            success: void 0 === params.success ? null : params.success,
            error: void 0 === params.error ? null : params.error,
            cancel: void 0 === params.cancel ? null : params.cancel,
        });
    },
    weixin: function(params){
        lxBridge.call('OAuth.weixin', null, {
            success: void 0 === params.success ? null : params.success,
            error: void 0 === params.error ? null : params.error,
            cancel: void 0 === params.cancel ? null : params.cancel,
        });
    },
    weibo: function(params){
        lxBridge.call('OAuth.weibo', null, {
            success: void 0 === params.success ? null : params.success,
            error: void 0 === params.error ? null : params.error,
            cancel: void 0 === params.cancel ? null : params.cancel,
        });
    },
};
var lxShare = {
    link: function(params){
        lxBridge.call('Share.link', params, {
            success: void 0 === params.success ? null : params.success,
            error: void 0 === params.error ? null : params.error,
            cancel: void 0 === params.cancel ? null : params.cancel,
        });
    },
};
var lxStorage = {
    write: function(params){
        if(void 0 != params.value)
        {
            params.value = JSON.stringify(params);
        }
        return JSON.parse(lxBridge.callStr('Storage.write', params));
    },
    read: function(params){
        return JSON.parse(lxBridge.callStr('Storage.read', params));
    },
    delete: function(params){
        return JSON.parse(lxBridge.callStr('Storage.delete', params));
    },
    getKeys: function(params){
        return JSON.parse(lxBridge.callStr('Storage.getKeys', params));
    },
};
var lxVersion = {
    init: function(){
        this.matches = navigator.userAgent.match(/LvXiu\/([^\/]+)\/([\d\.]+)/);
    },
    isApp: function(){
        return null !== this.matches;
    },
    isWeixin: function(){
        return null !== navigator.userAgent.match(/MicroMessenger/i);
    },
    getVersion: function(){
        return this.matches[2];
    },
    clientType: function(){
        return this.matches[1];
    },
};
lxVersion.init();