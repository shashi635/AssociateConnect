using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace Cog.MLIAD.BusinessLogic.Associate
{
    [DataContract]
    public class FirewallRequest
    {
        [DataMember]
        public int FirewallRequestID { get; set; }
        [DataMember]
        public string FirewallRequestDesc { get; set; }
        [DataMember]
        public string Destination { get; set; }
        [DataMember]
        public string Source { get; set; }
        [DataMember]
        public string Port { get; set; }
        [DataMember]
        public int ProjectID { get; set; }
        [DataMember]
        public string ProjectName { get; set; }
        [DataMember]
        public string id { get; set; }
        [DataMember]
        public string oper { get; set; }
    }

}
