using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace Cog.MLIAD.BusinessLogic.Associate
{
    [DataContract]
    public class Associate
    {
       #region ctor
        public Associate() { }
       #endregion
       #region public members
        [DataMember]
        public int? AssociateID { get; set; }
        [DataMember]
        public List<Address> Address { get; set; }
        [DataMember]
        public List<Phone> Phones { get; set; }
        [DataMember]
        public string Name { get; set; }
        [DataMember]
        public string FirstName { get; set; }
        [DataMember]
        public string LastName { get; set; }
        [DataMember]
        public string Mobile { get; set; }
        [DataMember]
        public string email { get; set; }
        [DataMember]
        public int DirectReportID { get; set; }
        [DataMember]
        public string DirectReporter { get; set; }
        //[DataMember]
        //public DateTime CreatedOn { get; set; }
        [DataMember]
        public int? ModifiedBy { get; set; }
        [DataMember]
        public DateTime? ModifiedOn { get; set; }
        [DataMember]
        public bool IsApproved { get; set; }
        [DataMember]
        public int ProjectID { get; set; }
        [DataMember]
        public string ProjectName { get; set; }
        [DataMember]
        public int? LocationID { get; set; }
        [DataMember]
        public string Location { get; set; }
        [DataMember]
        public int? DesignationID { get; set; }
        [DataMember]
        public string Designation { get; set; }
        [DataMember]
        public string Practice { get; set; }
        [DataMember]
        public string Account { get; set; }
        [DataMember]
        public string DOJ { get; set; }
        [DataMember]
        public string DOB { get; set; }
        [DataMember]
        public bool? IsActive { get; set; }
        [DataMember]
        public string Password { get; set; }
        [DataMember]
        public string UserID { get; set; }
        [DataMember]
        public string id { get; set; }
        [DataMember]
        public string oper { get; set; }
        [DataMember]
        public string Gender { get; set; }

        [DataMember]
        public Role Role { get; set; }
        [DataMember]
        public int GroupID { get; set; }
        [DataMember]
        public string GroupName { get; set; }
        [DataMember]
        public int RoleID { get; set; }
        [DataMember]
        public List<Group> groupList;
       #endregion
    }
}
