using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace Cog.MLIAD.BusinessLogic.Associate
{
    [DataContract]
    public class Address
    {
        #region ctor
        public Address() { }
        #endregion

        #region public members
        [DataMember]
        public int AddressID { get; set; }
        [DataMember]
        public string Address1 { get; set; }
        [DataMember]
        public string Address2 { get; set; }
        [DataMember]
        public string Address3 { get; set; }
        [DataMember]
        public string City { get; set; }
        [DataMember]
        public string State { get; set; }
        [DataMember]
        public string Country { get; set; }
        [DataMember]
        public string Zip { get; set; }
        [DataMember]
        public int? AddressTypeID { get; set; }
        [DataMember]
        public string AddressType { get; set; }
        #endregion
    }

}
