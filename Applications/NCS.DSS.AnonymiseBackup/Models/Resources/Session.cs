using System;
using NCS.DSS.Anonymise.ReferenceData;
using NCS.DSS.AnonymiseBackup.Helpers;

namespace NCS.DSS.AnonymiseBackup.Models.Resources
{
  
    public class Session : AnonHelper, IAnonymise
    {

        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public Guid? SessionId { get; set; }
        public Guid? CustomerId { get; set; }
        public Guid? InteractionId { get; set; }
        public DateTime? DateandTimeOfSession { get; set; }
        public string VenuePostCode { get; set; }
        public decimal? Longitude { get; set; }
        public decimal? Latitude { get; set; }
        public bool? SessionAttended { get; set; }
        public ReasonForNonAttendance? ReasonForNonAttendance { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public string LastModifiedTouchpointId { get; set; }
        public string SubcontractorId { get; set; }
        public string CreatedBy { get; set; }

        public void Anonymise()
        {
            VenuePostCode = RandomiseText(VenuePostCode);
            Latitude = null;
            Longitude = null;
        }

    }

}
