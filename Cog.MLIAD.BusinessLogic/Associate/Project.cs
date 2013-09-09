using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace Cog.MLIAD.BusinessLogic.Associate
{
    [DataContract]
    public class Project
    {
        #region ctor
        public Project() { }
        #endregion
        #region public members
        [DataMember]
        public int? ProjectID { get; set; }
        [DataMember]
        public string ProjectName { get; set; }
        public int Offshore { get; set; }
        public int Onshore { get; set; }
        public string Technology { get; set; }
        public int BuildTypeID { get; set; }
        public int AccountID { get; set; }
        public bool? IsActive { get; set; }
        #endregion
    }

}
