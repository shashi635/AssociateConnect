using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace Cog.MLIAD.BusinessLogic.Associate
{
    [DataContract]
    public class Group
    {
        [DataMember]
        public int? GroupID { get; set; }
        [DataMember]
        public string GroupName { get; set; }
        [DataMember]
        public string GroupDesc { get; set; }
    }

}
