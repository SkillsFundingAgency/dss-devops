using System;
using NCS.DSS.AnonymiseBackup.Helpers;

namespace NCS.DSS.AnonymiseBackup.Models.Resources
{
    public class AdviserDetail : AnonHelper, IAnonymise
    {
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public Guid? AdviserDetailId { get; set; }
        public string AdviserName { get; set; }
        public string AdviserEmailAddress { get; set; }
        public string AdviserContactNumber { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public string SubcontractorId { get; set; }
        public string CreatedBy { get; set; }

        public void Anonymise()
        {
            AdviserName = RandomiseText(AdviserName);
            AdviserEmailAddress = RandomiseText(AdviserEmailAddress);
            AdviserContactNumber = RandomPhoneNumber();
        }
  
    }
 
}
