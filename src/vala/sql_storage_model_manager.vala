
namespace MidgardCR {

	public class SQLStorageModelManager : GLib.Object, Model, Executable, StorageExecutor, StorageModelManager {

		/* internal properties */
		internal StorageManager _storage_manager = null;
		internal NamespaceManager _ns_manager = null;
		internal StorageModel[] _storage_models = null;
		internal SchemaModel[] _schema_models = null;
		internal Model[] _models = null;

		/* Model properties */
		/**
		 * SQLStorageModelManager doesn't hold parent model.
		 */	
		public Model? parent { 
			get { return null; }
			set { return; }
		}
		
		/**
		 * Namespace of the manager (if required)
		 */
                public string @namespace { get; set;  }

		/**
		 * Name of the manager (if required)
		 */
                public string name { get; set;  }

		/* properties */
		/**
		 * {@link NamespaceManager} of the manager
		 */
		public NamespaceManager namespace_manager { 
			get { return this._ns_manager; }
		}

		/**
		 * {@link StorageManager}
		 */
		public StorageManager storage_manager   { 
			get { return null; } 
		} 		

		/* Model methods */
		/**
                 * Associate new model 
                 *
                 * @param model {@link Model} to add
                 *
                 * @return {@link Model} instance (self reference)
                 */
		public Model add_model (Model model) {
			this._models += model;
			return this;
		}
		
		private bool _model_in_models (Model[] models, string name) {
			if (models == null)
				return false;
			foreach (Model model in models) {
				if (model.name == name)
					return true;
			}
			return false;
		}
		
		 /**
                 * Get model by given name. 
		 * SQLStorageModelManager holds {@link SchemaModel} and {@link StorageModel} models.
		 * First, search for SchemaModel is done, if none found, another search for 
		 * StorageModel is done. 
		 * In other words, given name might be the one of Schema or Storage model.
                 * 
                 * @param name {@link Model} name to look for
                 *
                 * @return {@link Model} if found, null otherwise
                 */
                public Model? get_model_by_name (string name) {
			if (this._models == null)
                                return null;

                        foreach (Model model in this._models) {
                                if (model.name == name)
                                        return model;
                        }
                        return null;
		}

		/**
		 * List all models associated with with an instance.
		 * See list_storage_models() and list_schema_models().
		 *
		 * @return array of models or null
		 */
                public unowned Model[]? list_models () {
			return this._models;
		}

		/**
		 * Always returns null
		 */
                public ModelReflector get_reflector () {
			return null;
		}

		/**
		 * Perform all checks required to mark instance as valid.
		 */
                public void is_valid () throws ValidationError {
			if (((MidgardCR.SQLStorageManager)this._storage_manager)._cnc == null)
				throw new MidgardCR.ValidationError.INTERNAL ("StorageManager not connected to any database"); 		
		}

		/* StorageExecutor methods */

		public bool exists () {
			return false;
		}

		/**
		 * Prepares create operation for all associated models.
		 * Valid SQL query (or prepared statement) is generated 
		 * in this method, so every model added after this method 
		 * call will be ignored and no its data will be included in 
		 * executed query.
		 */
		public void prepare_create () throws ValidationError {
			this.is_valid ();

			foreach (Model model in this._models) {
				if (this._model_in_models ((Model[])this._schema_models, model.name))
					throw new MidgardCR.ValidationError.NAME_DUPLICATED ("%s class already exists in schema table", model.name); 
			}		
		}

		private void _model_exists_in_storage () throws ValidationError {
			bool found = false;
			string invalid_name = "";
			foreach (Model model in this._models) {
				if (this._model_in_models ((Model[])this._schema_models, model.name)) {
					found = true;
					invalid_name = model.name;
					break;
				}
				if (this._model_in_models ((Model[])this._storage_models, model.name)) {
					found = true;
					invalid_name = model.name;
					break;
				}
			}
			if (!found)
				throw new MidgardCR.ValidationError.NAME_INVALID ("No entry in schema or storage table found for given %s ", invalid_name); 
		}

		/**
		 * Prepares update operation.
		 */
                public void prepare_update () throws ValidationError {
			this.is_valid ();
			this._model_exists_in_storage ();
		}

		/**
		 * Prepares save operation. 
		 */
                public void prepare_save () throws ValidationError {
			this.is_valid ();
			this._model_exists_in_storage ();
		}

		/**
		 * Prepares remove operation.
		 */
                public void prepare_remove () throws ValidationError {
			this.is_valid ();
			this._model_exists_in_storage ();
		}

		/**
		 * Prepares purge operation.
		 */
                public void prepare_purge () throws ValidationError {
			this.is_valid ();
			this._model_exists_in_storage ();
		}

		/* Executable methods */
		/**
		 * Executes SQL query generated in one of prepare methods.
		 * This method doesn't executes multiple queries of different types, so 
		 * execute should be invoked for every prepare method.
		 */
		public void execute () throws ExecutableError {

		}

		/* methods */
		/**
		 * Creates new StorageModel instance.
		 * 
		 * @param model, {@link SchemaModel) instance, which underlying 
		 * storage should be created for.
		 * @param location, name of the table which stores data of objects of the class
		 * represented by SchemaModel.
		 *
		 * @return StorageModel instance 
		 */
		public StorageModel create_storage_model (SchemaModel model, string location) {
			return null;
		}

		/**
		 * List all StorageModel models for which database entries already exist.
		 */
		public unowned StorageModel[]? list_storage_models () {
			return this._storage_models;
		}
		
		/**
		 * List all SchemaModel models for which database entries already exist.
		 */
		public unowned SchemaModel[]? list_schema_models () {
			return this._schema_models;
		}
	}
}