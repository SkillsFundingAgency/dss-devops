using System;
using NCS.DSS.Anonymise.ReferenceData;
using NCS.DSS.AnonymiseBackup.Helpers;

namespace NCS.DSS.AnonymiseBackup.Models.Resources
{
    public class Customer : AnonHelper, IAnonymise
    {
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public Guid? CustomerId { get; set; }
        public DateTime? DateOfRegistration { get; set; }
        public Title? Title { get; set; }
        public string GivenName { get; set; }
        public string FamilyName { get; set; }
        public DateTime? DateofBirth { get; set; }
        public Gender? Gender { get; set; }
        public string UniqueLearnerNumber { get; set; }
        public bool? OptInUserResearch { get; set; }
        public bool? OptInMarketResearch { get; set; }
        public DateTime? DateOfTermination { get; set; }
        public ReasonForTermination? ReasonForTermination { get; set; }
        public IntroducedBy? IntroducedBy { get; set; }
        public string IntroducedByAdditionalInfo { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public string LastModifiedTouchpointId { get; set; }
        public string SubcontractorId { get; set; }
        public string CreatedBy { get; set; }

        public void Anonymise()
        {
            GivenName = GetRandomForename(GivenName);
            FamilyName = GetRandomSurname(FamilyName);
            UniqueLearnerNumber = GetRandomNumberString(1000000000, 9999999999);
            DateofBirth = RandomDate();
            IntroducedByAdditionalInfo = RandomiseText(IntroducedByAdditionalInfo);
        }
    }
}
