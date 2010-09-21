
namespace MidgardCR {

	public errordomain ValidationError {
		NAME_INVALID,
		TYPE_INVALID,
		VALUE_INVALID,
		REFERENCE_INVALID,
		PARENT_INVALID,
		LOCATION_INVALID
	}

	public interface Model : GLib.Object {
		
		/* properties */
		public abstract Model       parent    { get; set; }
		public abstract string      @namespace       { get; set;  }
		public abstract string      name            { get; set;  }

		/* methods */
		public abstract Model add_model (Model model);
		public abstract Model? get_model_by_name (string name);
		public abstract Model[]? list_models ();
		public abstract ModelReflector get_reflector ();
	}

	public interface ModelProperty : GLib.Object, Model, Executable {
		
		/* properties */
		public abstract GLib.Type   valuegtype     { get; set; }
		public abstract string      valuetypename  { get; set; }
		public abstract string	    valuedefault   { get; set; }
		public abstract string      description     { get; set; }
		public abstract bool        @private      { get; set; }
	}
}
