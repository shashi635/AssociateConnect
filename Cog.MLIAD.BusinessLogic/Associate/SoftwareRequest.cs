using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace Cog.MLIAD.BusinessLogic.Associate
{
    [DataContract]
    public class SoftwareRequest
    {
        [DataMember]
        public int SoftRequestID { get; set; }
        [DataMember]
        public int SoftResourceID { get; set; }
        [DataMember]
        public int SoftCategoryID { get; set; }
        [DataMember]
        public int SoftVersionID { get; set; }
        [DataMember]
        public int ProjectID { get; set; }
        [DataMember]
        public string SoftResource { get; set; }
        [DataMember]
        public string SoftCategory { get; set; }
        [DataMember]
        public string SoftVersion { get; set; }
        [DataMember]
        public string ProjectName { get; set; }
        [DataMember]
        public string id { get; set; }
        [DataMember]
        public string oper { get; set; }
    }

}
