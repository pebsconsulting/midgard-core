
using GLib;

namespace MidgardCR {

	public class SQLStorageManager : GLib.Object, StorageManager {

		/* private properties */
		private string _name = "";
		private Config _config = null;
		private StorageContentManager _content_manager = null;
		private Profiler _profiler = null;
		private Transaction _transaction = null;
		private StorageWorkspaceManager _workspace_manager = null;
		private StorageModelManager _model_manager = null;

		/* protected properties */
		protected GLib.Object _cnc = null; /* <protected> */
		protected GLib.Object _parser = null;

		/* public properties */
		public string name { 
			get { return this._name; }
			construct { this._name = value; }
		}
		
		public Config config { 
			get { return this._config; }
			construct { this._config = value; }
		}

		public StorageContentManager content_manager {
			get { 
				/*if (this._content_manager == null)
					this._content_manager = StorageContentManager (); */
				return this._content_manager; 
			} 
		}

		public Profiler profiler {
			get { return _profiler; }
		}
			
		public Transaction transaction {
			get { return _transaction; }
		}
		
		public StorageWorkspaceManager workspace_manager {
			get { return _workspace_manager; }
		}

		public StorageModelManager model_manager {
			get { return _model_manager; }
		}	

		public SQLStorageManager (string name, Config config) throws StorageManagerError {
			if (name == "" || name == null)
				throw new MidgardCR.StorageManagerError.NAME_INVALID ("Can not initialize SQLStorageManager with empty name");

			Object (name: name, config: config);
		}

		public bool open () { 

			/* FIXME, throw error if it's opened already */
			try {
				MidgardCRCore.SQLStorageManager.open (this);
				return true;
			} catch (MidgardCR.StorageManagerError e) {
				throw e;
				return false;
			}		
		}

		public bool close () { return false; }

		public StorageManager fork () { return null; }
		public StorageManager clone () { return null; }
	}
}
