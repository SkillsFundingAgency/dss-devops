using System;
using NCS.DSS.Anonymise.ReferenceData;
using NCS.DSS.AnonymiseBackup.Helpers;

namespace NCS.DSS.AnonymiseBackup.Models.Resources
{
    public class ContactDetails : AnonHelper, IAnonymise
    {
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public Guid? ContactId { get; set; }
        public Guid? CustomerId { get; set; }
        public PreferredContactMethod? PreferredContactMethod { get; set; }
        public string MobileNumber { get; set; }
        public string HomeNumber { get; set; }
        public string AlternativeNumber { get; set; }
        public string EmailAddress { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public string LastModifiedTouchpointId { get; set; }

        public void Anonymise()
        {
            MobileNumber = RandomMobile();
            HomeNumber = RandomPhoneNumber();
            AlternativeNumber = RandomPhoneNumber();
            EmailAddress = RandomiseText(EmailAddress);
        }

    }
}