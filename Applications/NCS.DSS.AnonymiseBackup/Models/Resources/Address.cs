using System;
using NCS.DSS.AnonymiseBackup.Helpers;

namespace NCS.DSS.AnonymiseBackup.Models.Resources
{
    public class Address : AnonHelper, IAnonymise
    {
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public Guid? AddressId { get; set; }
        public Guid? CustomerId { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string Address3 { get; set; }
        public string Address4 { get; set; }
        public string Address5 { get; set; }
        public string PostCode { get; set; }
        public string AlternativePostCode { get; set; }
        public decimal? Longitude { get; set; }
        public decimal? Latitude { get; set; }
        public DateTime? EffectiveFrom { get; set; }
        public DateTime? EffectiveTo { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public string LastModifiedTouchpointId { get; set; }
        public string SubcontractorId { get; set; }
        public string CreatedBy { get; set; }

        public void Anonymise()
        {
            Address1 = RandomiseText(Address1);
            Address2 = RandomiseText(Address2);
            Address3 = RandomiseText(Address3);
            Address4 = RandomiseText(Address4);
            Address5 = RandomiseText(Address5);
            PostCode = GetRandomPostCode();
            AlternativePostCode = GetRandomPostCode();
            Latitude = null;
            Longitude = null;
        }
    }
}