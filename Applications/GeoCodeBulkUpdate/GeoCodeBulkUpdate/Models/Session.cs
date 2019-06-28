using System;
using GeoCodeBulkUpdate.ReferenceData;

namespace GeoCodeBulkUpdate.Models
{
    public class Session
    {
        private const string PostcodeRegEx = @"([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z]))))\s?[0-9][A-Za-z]{2})";

        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public Guid? SessionId { get; set; }

        public Guid? CustomerId { get; set; }

        public Guid? InteractionId { get; set; }

        public DateTime? DateandTimeOfSession { get; set; }

        public string VenuePostCode { get; set; }

        public bool? SessionAttended { get; set; }

        public ReasonForNonAttendance? ReasonForNonAttendance { get; set; }

        public DateTime? LastModifiedDate { get; set; }

        public string LastModifiedTouchpointId { get; set; }

        public string SubcontractorId { get; set; }

        public decimal? Longitude { get; set; }

        public decimal? Latitude { get; set; }

    }
}