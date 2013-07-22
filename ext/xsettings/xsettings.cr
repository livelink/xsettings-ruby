%pkg-config gtk+-2.0
%include gtk/gtk.h
%include gdk/gdk.h
%include gdk/gdkx.h

%{
#include "xsettings-manager.h"

static XSettingsManager *
manager_unwrap(VALUE obj)
{
	XSettingsManager *manager;
	Data_Get_Struct(obj, XSettingsManager, manager);
	return manager;
}

static void terminate_xsettings(void *value)
{
	if (value)
	{
		VALUE obj = (VALUE)value;
		rb_funcall(obj, rb_intern("terminated"),0);
	}
}

%}

%map VALUE > XSettingsManager* : manager_unwrap(%%)

module XSettings
class Manager
	pre_func XSettingsManager *_self = manager_unwrap(self); 
	def bool:self.exists?
		return xsettings_manager_check_running(GDK_DISPLAY(),
					    DefaultScreen(GDK_DISPLAY()));
	end
	def self.__alloc__()
		return Data_Wrap_Struct(self, NULL, 
		xsettings_manager_destroy, 
		xsettings_manager_new(GDK_DISPLAY(), 
			DefaultScreen(GDK_DISPLAY()),
			terminate_xsettings, (void*)self));
	end
	def terminated()
		_self = _self;
	end
	def destroy()
		xsettings_manager_destroy(_self);
	end
	def notify
		xsettings_manager_notify(_self);
	end
	def []=(char *name, value)
		switch(TYPE(value))
		{
		case T_NIL:
		case T_TRUE:
		case T_FALSE:
			xsettings_manager_set_int(_self, name, RTEST(value));
			break;
		case T_FIXNUM:
			xsettings_manager_set_int(_self, name, NUM2INT(value));
			break;
		case T_STRING:
			xsettings_manager_set_string(_self, name, StringValuePtr(value));
			break;
		case T_ARRAY:
			if (RARRAY_LEN(value) == 4) {
				XSettingsColor col;
				col.red   = NUM2INT(RARRAY_PTR(value)[0]);
				col.green = NUM2INT(RARRAY_PTR(value)[1]);
				col.blue  = NUM2INT(RARRAY_PTR(value)[2]);
				col.alpha = NUM2INT(RARRAY_PTR(value)[3]);
				xsettings_manager_set_color(_self, name, &col);
			}
			break;
		}
	end
end
end

