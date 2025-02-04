// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

#macro DT delta_time/1000000


function pointInRotRect(_px,_py,_parent,_ax,_ay,_dw,_dh){
	var _angle = _parent.angle;
	var _centx = _parent.absolutex+_parent.draww*.5;//_ax+_dw*.5;
	var _centy = _parent.absolutey+_parent.drawh*.5;//_ay+_dh*.5;
	var _p1dir = point_direction(_centx,_centy,_ax,_ay);
	var _p1dist = point_distance(_centx,_centy,_ax,_ay);
		
	var _p2dir = point_direction(_centx,_centy,_ax+_dw,_ay);
	var _p2dist = point_distance(_centx,_centy,_ax+_dw,_ay);
		
	var _p3dir = point_direction(_centx,_centy,_ax+_dw,_ay+_dh);
	var _p3dist = point_distance(_centx,_centy,_ax+_dw,_ay+_dh);
		
	var _p4dir = point_direction(_centx,_centy,_ax,_ay+_dh);
	var _p4dist = point_distance(_centx,_centy,_ax,_ay+_dh);
		
	var _p1x = _centx+dcos(_p1dir+_angle)*_p1dist;
	var _p1y = _centy-dsin(_p1dir+_angle)*_p1dist;
		
	var _p2x = _centx+dcos(_p2dir+_angle)*_p2dist;
	var _p2y = _centy-dsin(_p2dir+_angle)*_p2dist;
		
	var _p3x = _centx+dcos(_p3dir+_angle)*_p3dist;
	var _p3y = _centy-dsin(_p3dir+_angle)*_p3dist;
		
	var _p4x = _centx+dcos(_p4dir+_angle)*_p4dist;
	var _p4y = _centy-dsin(_p4dir+_angle)*_p4dist;
	draw_set_color(c_white);
	draw_triangle(_p1x,_p1y,_p2x,_p2y,_p3x,_p3y,true);
	draw_triangle(_p3x,_p3y,_p4x,_p4y,_p1x,_p1y,true);
	
	return point_in_triangle(_px,_py,_p1x,_p1y,_p2x,_p2y,_p3x,_p3y) || point_in_triangle(_px,_py,_p3x,_p3y,_p4x,_p4y,_p1x,_p1y);
}
/*
1  2

4  3
*/



function Udim(_scale, _offset) constructor {
	scale = _scale;
	offset = _offset;
	static Print = function(){
		show_debug_message("scale:"+string(scale)+",offset:"+string(offset));
	}
	static Add = function(_udim){
		scale += _udim.scale;
		offset += _udim.offset;
	}
}

function Udim2(_xscale=0,_yscale=0,_xoffset=0,_yoffset=0) constructor {
	xscale = _xscale;
	yscale = _yscale;
	xoffset = _xoffset;
	yoffset = _yoffset;
	static Print = function(){
		pstring = "xoffset:"+string(xoffset)+
			",yoffset:"+string(yoffset)+
			",xscale:"+string(xscale)+
			",yscale:"+string(yscale);
		show_debug_message(pstring);
	}
	static Add = function(_udim2){
		xscale += _udim2.xscale;
		yscale += _udim2.yscale;
		xoffset += _udim2.xoffset;
		yoffset += _udim2.yoffset;
	}
}



function Frame(_anchor=new Udim2(),_guiPosition=new Udim2(),_guiSize=new Udim2(,,32,32),_colors=[c_white,c_white,c_white,c_white],_alphas=[1,1,1,1],_angle=0) constructor {
	anchor = _anchor;
	guiPosition = _guiPosition;
	guiSize = _guiSize;
	colors = _colors;
	alphas = _alphas;
	angle = _angle;
	
	parentStruct = undefined;
	childrenStructs = [];
	drawx = guiPosition.xoffset+anchor.xoffset;
	drawy = guiPosition.yoffset+anchor.yoffset;
	draww = guiSize.xoffset;
	drawh = guiSize.yoffset;
	zdepth = 0;
	order = 0;
	clipDescendants = true;
	maskSurface = -1;
	clipSurface = -1;
	bordersRadius = [new Udim(), new Udim(), new Udim(), new Udim()];
	absolutex = drawx;
	absolutey = drawy;
	mousex = 0;
	mousey = 0;
	
	static Destroy = function(){
		for (var i=0;i<array_length(childrenStructs);i++){
			childrenStructs[i].Destroy();
			delete childrenStructs[i];
			//show_debug_message(childrenStructs[i]);
		}
		childrenStructs = [];
		//show_debug_message(self);
		parentStruct = undefined;
		show_debug_message("tried to delete struct");
	}
	static SetParent = function(_newParent){
		if (parentStruct!=_newParent){
			parentStruct = _newParent;
			show_debug_message(self);
			array_push(parentStruct.childrenStructs,self);
		}
	}
	static Draw = function(_dggw=display_get_gui_width(),_dggh=display_get_gui_height(),_dggx=0,_dggy=0,_mousex=device_mouse_x_to_gui(0),_mousey=device_mouse_y_to_gui(0)){
		drawx = guiPosition.xoffset+anchor.xoffset;
		drawy = guiPosition.yoffset+anchor.yoffset;
		draww = guiSize.xoffset;
		drawh = guiSize.yoffset;
		
		draww += _dggw*guiSize.xscale;
		drawh += _dggh*guiSize.yscale;
		drawx += _dggw*guiPosition.xscale-draww*anchor.xscale;
		drawy += _dggh*guiPosition.yscale-drawh*anchor.yscale;
		
		absolutex = drawx+_dggx;
		absolutey = drawy+_dggy;
		mousex = _mousex;//-_dggx;
		mousey = _mousey;//-_dggy;
		//angle += _angle;
		
		if clipDescendants {
			if (!surface_exists(maskSurface)) {
			    // create the maskSurface, if needed
			    maskSurface = surface_create(draww, drawh);
			    surface_set_target(maskSurface);
			    draw_clear(c_black);
				gpu_set_blendmode(bm_subtract);
			    // cut shapes out of the maskSurface:
			    //draw_circle(128, 128, 70, false);
				draw_rectangle(0,0,draww,drawh,false);
			    //
			    gpu_set_blendmode(bm_normal);
			    surface_reset_target();
			}
			if (!surface_exists(clipSurface)) {
			    // create the clipSurface, if needed
			    clipSurface = surface_create(draww, drawh);
			}
			// start drawing:
			surface_set_target(clipSurface);
			draw_clear_alpha(c_black, 0);
			// draw things relative to clipSurface:
			// draw all children
			
			draw_primitive_begin(pr_trianglestrip);
			//*
			draw_vertex_color(0,0,colors[0],alphas[0]);
			draw_vertex_color(0,drawh,colors[1],alphas[1]);
			draw_vertex_color(draww,0,colors[2],alphas[2]);
			draw_vertex_color(draww,drawh,colors[3],alphas[3]);
			/*/
			draw_vertex_color(-drawx,-drawy,colors[0],alphas[0]);
			draw_vertex_color(-drawx,-drawy+drawh,colors[1],alphas[1]);
			draw_vertex_color(-drawx+draww,-drawy,colors[2],alphas[2]);
			draw_vertex_color(-drawx+draww,-drawy+drawh,colors[3],alphas[3]);
			//*/
			draw_primitive_end();
			for (var i=0;i<array_length(childrenStructs);++i){
				childrenStructs[i].Draw(draww,drawh,drawx,drawy,mousex,mousey,angle);
			}
			//draw_circle(mouse_x, mouse_y, 40, false);
			// cut out the maskSurface from it:
			gpu_set_blendmode(bm_subtract);
			draw_surface(maskSurface, 0, 0);
			gpu_set_blendmode(bm_normal);
			// finish and draw the clipSurface itself:
			surface_reset_target();
			
			
			var _mx = surface_get_width(clipSurface) / 2;
			var _my = surface_get_height(clipSurface) / 2;
			var _mat = matrix_get(matrix_world);
			matrix_stack_push(matrix_build(drawx+_mx, drawy+_my, 0, 0, 0, angle, 1, 1, 1));
			matrix_stack_push(matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1));
			matrix_set(matrix_world, matrix_stack_top());
			draw_surface_ext(clipSurface, -_mx, -_my, 1, 1, 0, c_white, 1);
			//draw_surface_ext(clipSurface, absolutex, absolutey, 1, 1, 0, c_white, 1);
			matrix_stack_pop();
			matrix_stack_pop();
			matrix_set(matrix_world, _mat);
			
			//draw_surface_ext(clipSurface, drawx, drawy,1,1,angle,c_white,1);
		} else {
			draw_primitive_begin(pr_trianglestrip);
			draw_vertex_color(drawx,drawy,colors[0],alphas[0]);
			draw_vertex_color(drawx,drawy+drawh,colors[1],alphas[1]);
			draw_vertex_color(drawx+draww,drawy,colors[2],alphas[2]);
			draw_vertex_color(drawx+draww,drawy+drawh,colors[3],alphas[3]);
			draw_primitive_end();
			for (var i=0;i<array_length(childrenStructs);++i){
				childrenStructs[i].Draw(draww,drawh,drawx,drawy,mousex,mousey,angle);
			}
			show_debug_message("reached else" );
		}
	}
}

function Button(_canClick = true, _mouseDown=function(){}, _mouseUp=function(){}, _mouseHoverEnter=function(){}, _mouseHoverLeave=function(){}) : Frame() constructor{
	canClick = _canClick;
	mouseDown = _mouseDown;
	mouseUp = _mouseUp;
	mouseHoverEnter = _mouseHoverEnter;
	mouseHoverLeave = _mouseHoverLeave;
	mouseOn = false;
	
	step = function(){
		//if point_in_rectangle(mousex,mousey,absolutex,absolutey,absolutex+draww,absolutey+drawh){
		
		
		
		if pointInRotRect(mousex,mousey,parentStruct,absolutex,absolutey,draww,drawh){
			if !mouseOn{
				mouseHoverEnter();
				mouseOn = true;
				show_debug_message(absolutey);
				
			}
			if canClick{
				if mouse_check_button_pressed(mb_left){
					mouseDown();
				}
				if mouse_check_button_released(mb_left){
					mouseUp();
				}
			}
		} else {
			if mouseOn{
				mouseHoverLeave();
				mouseOn = false;
			}
		}
	}
	
}

function TextLabel(_text,_textScaled=true,_textSize=16,_graphemeCount=-1,_fontColors=[c_black,c_black,c_black,c_black],_fontAlpha=1) : Frame() constructor {
	text = _text;
	fontColors = _fontColors;
	fontAlpha = _fontAlpha;
	static frameDraw = Draw;
	static Draw = function(){
		draw_text_color(drawx,drawy,text,fontColors[0],fontColors[1],fontColors[2],fontColors[3],fontAlpha);
	}
}


