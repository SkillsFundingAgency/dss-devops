using System;
using System.ComponentModel;
using NCS.DSS.AnonymiseBackup.Helpers;

namespace NCS.DSS.AnonymiseBackup.Models.Resources
{

    public enum Channel
    {
        [Description("Face to face")]
        FaceToFace = 1,
        Telephone = 2,
        Webchat = 3,
        Videochat = 4,
        Email = 5,
        [Description("Social media")]
        SocialMedia = 6,
        SMS = 7,
        Post = 8,
        [Description("Co-browse")]
        Cobrowse = 9,
        Other = 99
    }

    public enum InteractionType
    {
        [Description("Transfer to touchpoint")]
        TransferToTouchPoint = 1,

        [Description("Webchat")]
        WebChat = 2,

        [Description("Book an appointment")]
        BookAnAppointment = 3,

        [Description("Creation of actionplan")]
        CreationOfActionPlan = 4,

        [Description("Telephone call")]
        TelephoneCall = 5,

        [Description("Request to be contacted")]
        RequestToBeContacted = 6,

        [Description("Request for technical help")]
        RequestForTechnicalHelp = 7,

        [Description("Provides feedback")]
        ProvidesFeedback = 8,

        [Description("Complaint")]
        Complaint = 9,

        [Description("Voice of customer survey")]
        VoiceOfCustomerSurvey = 10,

        [Description("Other")]
        Other = 99

    }


    public class Interaction : AnonHelper, IAnonymise
    {
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public Guid? InteractionId { get; set; }
        public Guid? CustomerId { get; set; }
        public string TouchpointId { get; set; }
        public Guid? AdviserDetailsId { get; set; }
        public DateTime? DateandTimeOfInteraction { get; set; }
        public Channel? Channel { get; set; }
        public InteractionType? InteractionType { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public string LastModifiedTouchpointId { get; set; }

        public void Anonymise()
        {

        }
    }
}
