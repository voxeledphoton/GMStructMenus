/// @description Insert description here
// You can write your code in this editor


display_set_gui_size(camera_get_view_width(view_camera[0]),camera_get_view_height(view_camera[0]));


test = new Udim2();
test.Print();

MainFrame = new Frame();
MainFrame.anchor = new Udim2(0,0);
MainFrame.guiPosition = new Udim2(0,0);
MainFrame.guiSize = new Udim2(1,1);
MainFrame.alphas = [1,1,1,1];
MainFrame.clipDescendants = true;
MainFrame.colors = [c_navy,c_navy,c_navy,c_navy];



frame2 = new Frame();
frame2.anchor = new Udim2(.5,.5);
frame2.guiPosition = new Udim2(.5,.5);
frame2.guiSize = new Udim2(.5,.5);
frame2.colors = [c_lime,c_lime,c_lime,c_lime];
frame2.alphas = [1,1,1,1];
frame2.clipDescendants = true;
frame2.angle = 45;
frame2.step = function(){
	//frame2.guiPosition = new Udim2(sin(current_time*.001)*.1+.5,.5);
	frame2.angle = 0+sin(current_time*.001)*5;
}
frame2.SetParent(MainFrame);

label = new TextLabel("blah",true,,,,,);
label.guiPosition = new Udim2(.5,.5);
label.SetParent(frame2);

btn = new Button(
	,
	function(){show_debug_message("mouse pressed button")},
	function(){show_debug_message("mouse released button")},
	function(){show_debug_message("mouse is over button")},
	function(){show_debug_message("mouse left button")});
btn.guiPosition = new Udim2(0,0,64,64);
btn.SetParent(frame2);




function ExecuteMethodsInChild(_parent,_name) {
	for (var i = 0; i < array_length(_parent.childrenStructs); i++) {
		var _value = variable_struct_get(_parent.childrenStructs[i],_name);
		if (!is_undefined(_value) ){
			if (typeof(_value) == "method"){
				_value();
			}
		}
		if (array_length(_parent.childrenStructs[i].childrenStructs) > 0) {
			ExecuteMethodsInChild(_parent.childrenStructs[i],_name);
		}
	}
}


//function ExecuteMethodsInChild(_parent,_name) {
//	for (var i = 0; i < array_length(_parent.childrenStructs); i++) {
//		var _value = variable_struct_get(_parent.childrenStructs[i],_name);
//		if (!is_undefined(_value) ){
//			if (typeof(_value) == "method"){
//				_value();
//			}
//		}
//		//var keys = variable_struct_get_names(_parent.childrenStructs[i]);
//		//for (var j = array_length(keys)-1; j >= 0; --j) {
//		//    var k = keys[j];
//		//    var v = _parent.childrenStructs[i][$ k];

//		//    if (typeof(v) == "method") {
//		//        v();
//		//    }
//		//    /* Use k and v here */
//		//}
//		if (array_length(_parent.childrenStructs[i].childrenStructs) > 0) {
//			ExecuteMethodsInChild(_parent.childrenStructs[i])
//		}
//	}
//}






//var btnTest = new Button();
//btnTest.SetParent(frame2);
//btnTest.alphas = [.5,.5,.5,.5];
//btnTest.guiSize = new Udim2(1,0,0,32);

//var btnTest2 = new Button();
//btnTest2.SetParent(frame2);
//btnTest2.alphas = [.5,.5,.5,.5];
//btnTest2.guiSize = new Udim2(1,0,0,32);
//btnTest2.guiPosition = new Udim2(0,.5);


show_debug_message(MainFrame);

//alarm[0] = room_speed*10;
