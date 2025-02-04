/// @description Insert description here
// You can write your code in this editor



if (!is_undefined(MainFrame) ){
	MainFrame.Draw();
	ExecuteMethodsInChild(MainFrame,"draw");
}

//if (!is_undefined(frame2) ){
//	frame2.Draw();
//}


//show_debug_message(btn.drawx);
//show_debug_message(MainFrame.drawx);

draw_text(0,128,string(fps_real));
